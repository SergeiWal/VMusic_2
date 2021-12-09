--импорт данных из xml
--каждая процедура принимает строку - xml-документ

create or replace package import_xml is

procedure import_genres_xml
    (xml_string IN nvarchar2);
procedure import_authors_xml
    (xml_string IN nvarchar2);
procedure import_songs_xml
    (xml_string IN nvarchar2);
procedure import_roles_xml
    (xml_string IN nvarchar2);
procedure import_users_xml
    (xml_string IN nvarchar2);
procedure import_playlists_xml
    (xml_string IN nvarchar2);
procedure import_relationships_xml
    (xml_string IN nvarchar2);

end import_xml;


create or replace package body  import_xml is
    --genres
procedure import_genres_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'genre/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'genre/name') as genre
            from table ( XMLSEQUENCE( EXTRACT(xml,'/genres/genre'))) xmldummay
       ) loop
       insert into GENRE(id, genre)
            values (r.id, r.genre);
       end loop;
end;

--authors
procedure import_authors_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'author/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'author/name') as name
            from table ( XMLSEQUENCE( EXTRACT(xml,'/authors/author'))) xmldummay
       ) loop
       insert into author(id, name)
            values (r.id, r.name);
       end loop;
end;


--songs
procedure import_songs_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'song/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'song/name') as name,
              EXTRACTVALUE(COLUMN_VALUE, 'song/source') as source,
              EXTRACTVALUE(COLUMN_VALUE, 'song/author') as author,
              EXTRACTVALUE(COLUMN_VALUE, 'song/genre') as genre
            from table ( XMLSEQUENCE( EXTRACT(xml,'/songs/song'))) xmldummay
       ) loop
       insert into song(id, name,source,author,genre)
            values (r.id, r.name,r.source,r.author,r.genre);
       end loop;
end;


--user_roles
procedure import_roles_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'role/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'role/name') as role
            from table ( XMLSEQUENCE( EXTRACT(xml,'/roles/role'))) xmldummay
       ) loop
       insert into user_role(id, role)
            values (r.id, r.role);
       end loop;
end;

--users
procedure import_users_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'user/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'user/name') as name,
              EXTRACTVALUE(COLUMN_VALUE, 'user/password') as password,
              EXTRACTVALUE(COLUMN_VALUE, 'user/role') as role
            from table ( XMLSEQUENCE( EXTRACT(xml,'/users/user'))) xmldummay
       ) loop
       insert into vmusic_user(id, name, password, role)
            values (r.id, r.name, r.password, r.role);
       end loop;
end;

--playlists
procedure import_playlists_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'playlist/id') as id,
              EXTRACTVALUE(COLUMN_VALUE, 'playlist/name') as name,
              EXTRACTVALUE(COLUMN_VALUE, 'playlist/owner') as owner
            from table ( XMLSEQUENCE( EXTRACT(xml,'/playlists/playlist'))) xmldummay
       ) loop
       insert into PLAYLIST(id, name, owner)
            values (r.id, r.name, r.owner);
       end loop;
end;

--playlist song relationships
procedure import_relationships_xml
    (xml_string IN nvarchar2) is
    xml XMLTYPE := XMLTYPE(xml_string);
begin
    for r in (
       select EXTRACTVALUE(COLUMN_VALUE, 'relationship/playlistId') as playlistId,
              EXTRACTVALUE(COLUMN_VALUE, 'relationship/songId') as songId
            from table ( XMLSEQUENCE( EXTRACT(xml,'/relationships/relationship'))) xmldummay
       ) loop
       insert into PLAYLIST_SONGS(playlist_id, song_id)
            values (r.playlistId, r.songId);
       end loop;
end;
end import_xml;




--tests

-- select * from GENRE;
--
-- select * from AUTHOR;
-- select * from SONG;
--
-- select * from USER_ROLE;
-- select * from VMUSIC_USER;
--
-- select * from PLAYLIST;
--
-- select * from PLAYLIST_SONGS;

-- -- --procedures invokes
-- begin
--     --import_genres_xml('');
--    -- import_authors_xml();
--     --import_songs_xml('');
--     --IMPORT_ROLES_XML('');
--     --import_users_xml('');
--     --IMPORT_PLAYLISTS_XML('');
--     --IMPORT_RELATIONSHIPS_XML('');
-- end;