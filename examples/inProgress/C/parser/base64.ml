(* Copyright (c) 2004 by Dustin Sallings

The package "Dustin's O'Caml lib" is copyright by Dustin Sallings.

Permission is hereby granted, free of charge, to any person obtaining a copy of
the "Dustin's O'Caml lib" software (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

The Software is provided ``as is'', without warranty of any kind, expressed or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement.  In no event shall Dustin
Sallings be liable for any claim, damages or other liability, whether in an
action of contract, tort or otherwise, arising from, out of or in connection
with the Software or the use or other dealings in the software.

# arch-tag: 16197850-C175-11D8-8540-000393CFE6B8
*)

(*
 * Copyright (c) 2003  Dustin Sallings <dustin@spy.net>
 *
 * arch-tag: 2018780E-294F-11D8-9B49-000393CB0F1E
 *)

(**
 Base64 stream encoder/decoder.
 *)

(** Exception raised when there's an attempt to encode a chunk incorrectly *)
exception Invalid_encode_chunk of int

(** The character map of all base64 characters *)
let char_map = [|
	'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'; 'M';
	'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V'; 'W'; 'X'; 'Y'; 'Z';
	'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'; 'l'; 'm';
	'n'; 'o'; 'p'; 'q'; 'r'; 's'; 't'; 'u'; 'v'; 'w'; 'x'; 'y'; 'z';
	'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '+'; '/'|]

(** {1 Functions for encoding} *)

(** Encode a chunk.  The chunk is either a 1, 2, or 3 element array. *)
let encode_chunk chars =
	let llength = List.length chars in
	if(llength = 0 || llength > 3) then
		raise (Invalid_encode_chunk(llength));
	let chunk = String.make 4 '=' in
	let a = List.hd chars in
	let tmpa = (((Char.code a) land 3) lsl 4) in
	chunk.[0] <- char_map.( (Char.code a) lsr 2);
	(* Check for another character *)
	if (llength < 2) then (
		chunk.[1] <- char_map.(tmpa);
		chunk;
	) else (
		let b = List.nth chars 1 in
		let tmpb = ((Char.code b) lsr 4) in
		let tmpa2 = ((Char.code b) land 0x0f) lsl 2 in
		chunk.[1] <- char_map.(tmpa lor tmpb);
		if (llength < 3) then (
			chunk.[2] <- char_map.(tmpa2);
			chunk
		) else (
			let c = List.nth chars 2 in
			let tmpb2 = ((Char.code c) land 0xc0) lsr 6 in
			chunk.[2] <- char_map.(tmpa2 lor tmpb2);
			chunk.[3] <- char_map.((Char.code c) land 0x3f);
			chunk
		)
	)

(** Stream chunk encoder.

 Use ``Stream.from'' to produce a stream of encoded data from a data stream.
 *)
let encode_stream_chunk data_stream cnt =
	let stream_empty s =
		try
			Stream.empty s;
			true
		with Stream.Failure -> false in
	if (stream_empty data_stream) then (
		None
	) else (
		let next = Stream.npeek 3 data_stream in
		List.iter (fun x -> Stream.junk data_stream) next;
		(* We don't do 76 here as they're in blocks of 4. *)
		Some (encode_chunk next ^
			(if (((cnt + 1) mod 19) = 0) then "\r\n" else ""))
	)

(**
 Get a Stream of encoded data from the given stream of data.
 *)
let encode data_stream =
	Stream.from (encode_stream_chunk data_stream)

(**
 Base64 encode the string data into a base64 encoded string.
 *)
let encode_to_string data_stream =
	let buf = Buffer.create 512 in
	Stream.iter (fun c -> Buffer.add_string buf c) (encode data_stream);
	Buffer.contents buf

(** Base64 encode a string *)
let encode_string s = encode_to_string (Stream.of_string s)

(* ---------------------------------------------------------------------- *)

(** {1 Functions for decoding} *)

(** Exception raised when there's a problem with the input stream. *)
exception Invalid_decode_chunk of int

(** Reverse mapping of character to its index in the char_map *)
let char_index =
	let rv = Array.make 256 (-1) in
	for i = 0 to (Array.length char_map - 1) do
		let c = char_map.(i) in
		Array.set rv (Char.code c) i
	done;
	rv

(** Is the given character a valid base64 character? *)
let is_base64_char c =
	char_index.(Char.code c) != -1

(** Decode a chunk represented as a list of characters.
 The chunk must be 2, 3, or 4 elements large.
 *)
let decode_chunk chars =
	let rv = Buffer.create 3 in
	let fchars = (List.filter (fun c -> c != '=') chars) in
	let packer = List.fold_left (fun o x -> (o lsl 6) lor x) 0
		(List.map (fun c -> char_index.(Char.code c)) fchars) in
	(
	match List.length fchars with
		| 4 ->
			Buffer.add_char rv (Char.chr (0xff land (packer lsr 16)));
			Buffer.add_char rv (Char.chr (0xff land (packer lsr 8)));
			Buffer.add_char rv (Char.chr (0xff land packer));
		| 3 ->
			Buffer.add_char rv (Char.chr (0xff land ((packer lsl 6) lsr 16)));
			Buffer.add_char rv (Char.chr (0xff land ((packer lsl 6) lsr 8)));
		| 2 ->
			Buffer.add_char rv (Char.chr (0xff land ((packer lsl 12) lsr 16)));
		| _ -> raise (Invalid_decode_chunk(List.length fchars));
	);
	Buffer.contents rv

(** Decode a stream of base64 characters into a stream of 3 or fewer byte
	strings.
 *)
let decode data_stream =
	let rec find_next x =
		try
			Stream.empty data_stream;
			None
		with Stream.Failure -> (
			let rv = Stream.next data_stream in
			if (is_base64_char(rv)) then
				Some rv
			else (find_next x)
		) in
	let clean_stream = Stream.from find_next in
	let get_block x =
		try
			let chunk = Stream.npeek 4 clean_stream in
			List.iter (fun x -> Stream.junk clean_stream) chunk;
			match chunk with
				  [] -> None
				| _  -> Some(decode_chunk chunk)
		with Stream.Failure -> None in
	Stream.from get_block

(**
 Base64 decode the stream of base64 encoded data into a string.
 *)
let decode_to_string data_stream =
	let buf = Buffer.create 512 in
	Stream.iter (fun c -> Buffer.add_string buf c) (decode data_stream);
	Buffer.contents buf

(** Base64 decode a string to a string *)
let decode_string s = decode_to_string (Stream.of_string s)

(** {1 Functions for testing } *)

(** Simple test function. *)
let test() =
	let wordlist = ["A";"AB";"ABC";"Dustin";String.create 128] in
	print_endline("String:");
	List.iter (fun x -> print_endline(encode_string x))
		wordlist;
	print_endline("Stream:");
	List.iter (fun x ->
			Stream.iter print_string (encode (Stream.of_string x));
			print_newline()
		) wordlist;
	print_endline("Decode:");
	List.iter (fun x -> print_endline(decode_string (encode_string x)))
		wordlist
