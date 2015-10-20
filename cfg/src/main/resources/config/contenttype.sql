/*
*    auxiliary tables - contenttype
*/


-- https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_MIME-%D1%82%D0%B8%D0%BF%D0%BE%D0%B2
drop table if exists contentType cascade;
create table contentType (
    id serial not null primary key,
    parentId int,
    value varchar(255),
    download boolean default 'no',
    description varchar(255)
);

copy  contentType(id,value) from stdin;
1	application
2	audio
3	example
4	image
5	message
6	model
7	multipart
8	text
9	video
10	vendor
11	pkcs
12	unknown+nonstandart
\.


-- application
SELECT setval('contenttype_id_seq', 120);

copy  contentType(parentId,value,description) from stdin;
1	application/atom+xml	Atom
1	application/EDI-X12	EDI X12 (RFC 1767)
1	application/EDIFACT	EDI EDIFACT (RFC 1767)
1	application/json	JavaScript Object Notation JSON (RFC 4627)
1	application/javascript	JavaScript (RFC 4329)
1	application/octet-stream	двоичный файл без указания формата (RFC 2046)
1	application/ogg	Ogg (RFC 5334)
1	application/pdf	Portable Document Format, PDF (RFC 3778)
1	application/postscript	PostScript (RFC 2046)
1	application/soap+xml	SOAP (RFC 3902)
1	application/x-woff	Web Open Font Format
1	application/xhtml+xml	XHTML (RFC 3236)
1	application/xml-dtd	DTD (RFC 3023)
1	application/xop+xml	XOP
1	application/zip	ZIP
1	application/gzip	Gzip
1	application/x-bittorrent	BitTorrent
1	application/x-tex	TeX
\.

--audio
SELECT setval('contenttype_id_seq', 220);

copy  contentType(parentId,value,description) from stdin;
2	audio/basic	mulaw аудио, 8 кГц, 1 канал (RFC 2046)
2	audio/L24	24bit Linear PCM аудио, 8-48 кГц, 1-N каналов (RFC 3190)
2	audio/mp4	MP4
2	audio/aac	AAC
2	audio/mpeg	MP3 или др. MPEG (RFC 3003)
2	audio/ogg	Ogg Vorbis, Speex, Flac или др. аудио (RFC 5334)
2	audio/vorbis	Vorbis (RFC 5215)
2	audio/x-ms-wma	Windows Media Audio
2	audio/x-ms-wax	Windows Media Audio перенаправление
2	audio/vnd.rn-realaudio	RealAudio
2	audio/vnd.wave	WAV(RFC 2361)
2	audio/webm	WebM
\.

--image
SELECT setval('contenttype_id_seq', 320);

copy  contentType(parentId,value,description) from stdin;
4	image/gif	GIF(RFC 2045 и RFC 2046)
4	image/jpeg	JPEG (RFC 2045 и RFC 2046)
4	image/pjpeg	JPEG
4	image/png	Portable Network Graphics (RFC 2083)
4	image/svg+xml	SVG
4	image/tiff	TIFF(RFC 3302)
4	image/vnd.microsoft.icon	ICO
4	image/vnd.wap.wbmp	WBMP
\.


--message
SELECT setval('contenttype_id_seq', 420);

copy  contentType(parentId,value,description) from stdin;
5	message/http	(RFC 2616)
5	message/imdn+xml	IMDN (RFC 5438)
5	message/partial	E-mail (RFC 2045 и RFC 2046)
5	message/rfc822	E-mail; EML файлы, MIME файлы, MHT файлы, MHTML файлы (RFC 2045 и RFC 2046)
\.


--model
SELECT setval('contenttype_id_seq', 520);

copy  contentType(parentId,value,description) from stdin;
6	model/example	(RFC 4735)
6	model/iges	IGS файлы, IGES файлы (RFC 2077)
6	model/mesh	MSH файлы, MESH файлы (RFC 2077), SILO файлы
6	model/vrml	WRL файлы, VRML файлы (RFC 2077)
6	model/x3d+binary	X3D ISO стандарт для 3D компьютерной графики, X3DB файлы
6	model/x3d+vrml	X3D ISO стандарт для 3D компьютерной графики, X3DV VRML файлы
6	model/x3d+xml	X3D ISO стандарт для 3D компютерной графики, X3D XML файлы
\.

--multipart
SELECT setval('contenttype_id_seq', 611);

copy  contentType(parentId,value,description) from stdin;
7	multipart/mixed	MIME E-mail (RFC 2045 и RFC 2046)
7	multipart/alternative	MIME E-mail (RFC 2045 и RFC 2046)
7	multipart/related	MIME E-mail (RFC 2387 и используемое MHTML (HTML mail))
7	multipart/form-data	MIME Webform (RFC 2388)
7	multipart/signed	(RFC 1847)
7	multipart/encrypted	(RFC 1847)
\.

--text
SELECT setval('contenttype_id_seq', 650);

copy  contentType(parentId,value,description) from stdin;
8	text/cmd	команды
8	text/css	Cascading Style Sheets (RFC 2318)
8	text/csv	CSV (RFC 4180)
8	text/html	HTML (RFC 2854)
8	text/javascript	(Obsolete) JavaScript(RFC 4329)
8	text/plain	текстовые данные (RFC 2046 и RFC 3676)
8	text/php	Скрипт языка PHP
8	text/xml	Extensible Markup Language (RFC 3023)
\.

--video
SELECT setval('contenttype_id_seq', 730);

copy  contentType(parentId,value,description) from stdin;
9	video/mpeg	MPEG-1 (RFC 2045 и RFC 2046)
9	video/mp4	MP4 (RFC 4337)
9	video/ogg	Ogg Theora или другое видео (RFC 5334)
9	video/quicktime	QuickTime[11]
9	video/webm	WebM
9	video/x-ms-wmv	Windows Media Video[5]
9	video/x-flv	FLV
9	video/3gpp	.3gpp .3gp
9	video/3gpp2	.3gpp2 .3g2 
\.

--vendor
SELECT setval('contenttype_id_seq', 820);

copy  contentType(parentId,value,description) from stdin;
10	application/vnd.oasis.opendocument.text	OpenDocument
10	application/vnd.oasis.opendocument.spreadsheet	OpenDocument
10	application/vnd.oasis.opendocument.presentation	OpenDocument
10	application/vnd.oasis.opendocument.graphics	OpenDocument
10	application/vnd.ms-excel	Microsoft Excel файлы
10	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel 2007 файлы
10	application/vnd.ms-powerpoint	Microsoft Powerpoint файлы
10	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint 2007 файлы
10	application/msword	Microsoft Word файлы
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word 2007 файлы
10	application/vnd.mozilla.xul+xml	Mozilla XUL файлы
10	application/vnd.google-earth.kml+xml	KML файлы (например, для Google Earth)
\.

--pkcs
SELECT setval('contenttype_id_seq', 940);

copy  contentType(parentId,value,description) from stdin;
11	application/x-pkcs12	p12 файлы
11	application/x-pkcs12	pfx файлы
11	application/x-pkcs7-certificates	p7b файлы
11	application/x-pkcs7-certificates	spc файлы
11	application/x-pkcs7-certreqresp	p7r файлы
11	application/x-pkcs7-mime	p7c файлы
11	application/x-pkcs7-mime	p7m файлы
11	application/x-pkcs7-signature	p7s файлы
\.

--unknown+nonstandart
SELECT setval('contenttype_id_seq', 1001);

copy  contentType(parentId,value,description) from stdin;
12	application/x-www-form-urlencoded	Form Encoded Data
12	application/x-dvi	DVI
12	application/x-latex	LaTeX файлы
12	application/x-font-ttf	TrueType (не зарегистрированный MIME-тип, но наиболее часто используемый)
12	application/x-shockwave-flash	Adobe Flash
12	application/x-stuffit	StuffIt
12	application/x-rar-compressed	RAR
12	application/x-tar	Tarball
12	text/x-jquery-tmpl	jQuery
12	application/x-javascript	no desc
12	-	unknown type from squid access.log
\.

drop function if exists getContentTypeId(varchar);
create or replace function getContentTypeId(cType varchar)
returns int
immutable
as
$$
declare
    result int;
begin
    cType=lower(trim(cType));
    select id into result from contenttype where lower(trim(value))=cType;
    return result;

end;
$$ language plpgsql;

---popultate content type
drop function if exists popContentType(varchar);
create or replace function popContentType(cType varchar)
returns int
as
$$
declare
    result int;
begin
    cType=lower(trim(cType));
    select id into result from contenttype where lower(trim(value))=cType;
    if result is null
     then
	select nextval('contenttype_id_seq') into result;
	insert into contenttype(id,parentId,value,description) 
				    values(result,
				    12, --unknown+nonstandart
				    cType,
				    'auto-insert');

    end if;
    return result;
end;
$$ language plpgsql ;

