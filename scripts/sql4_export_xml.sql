--экспорт данных из таблиц в xml
--процедуры имеют один выходной параметер - строку содержащую xml


--genres
create or replace procedure export_genres_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(1000);
begin
    xml_string:='<genres>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('genre'),
           XMLELEMENT(EVALNAME('id'),g.ID ),
           XMLELEMENT(EVALNAME('name'), g.GENRE)) as XML
    from GENRE g;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
    xml_string:= xml_string || '</genres>';
end;


--authors
create or replace procedure export_authors_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<authors>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('author'),
           XMLELEMENT(EVALNAME('id'),a.ID ),
           XMLELEMENT(EVALNAME('name'), a.NAME)) as XML
    from AUTHOR a;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</authors>';
end;

--songs
create or replace procedure export_songs_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<songs>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('song'),
           XMLELEMENT(EVALNAME('id'),s.ID ),
           XMLELEMENT(EVALNAME('name'), s.NAME),
           XMLELEMENT(EVALNAME('author'), s.AUTHOR),
           XMLELEMENT(EVALNAME('genre'), s.GENRE),
           XMLELEMENT(EVALNAME('source'), s.SOURCE)
           ) as XML
    from SONG s;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</songs>';
end;

--user_roles
create or replace procedure export_roles_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<roles>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('role'),
           XMLELEMENT(EVALNAME('id'),ur.ID ),
           XMLELEMENT(EVALNAME('name'), ur.ROLE)
           ) as XML
    from USER_ROLE ur;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</roles>';
end;

--users
create or replace procedure export_users_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<users>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('user'),
           XMLELEMENT(EVALNAME('id'),u.ID ),
           XMLELEMENT(EVALNAME('name'), u.NAME),
           XMLELEMENT(EVALNAME('password'), u.PASSWORD),
           XMLELEMENT(EVALNAME('role'), u.ROLE)
           ) as XML
    from VMUSIC_USER u;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</users>';
end;

--playlists
create or replace procedure export_playlists_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<playlists>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('playlist'),
           XMLELEMENT(EVALNAME('id'),p.ID ),
           XMLELEMENT(EVALNAME('name'), p.NAME),
           XMLELEMENT(EVALNAME('owner'), p.OWNER)
           ) as XML
    from PLAYLIST p;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</playlists>';
end;

--relationships
create or replace procedure export_relationships_to_xml
    (xml_string OUT nvarchar2)
    is
    result_set  sys_refcursor;
    xml_data nvarchar2(300);
begin
    xml_string:='<relationships>';
    open result_set for
        select
       XMLELEMENT(EVALNAME('relationship'),
           XMLELEMENT(EVALNAME('playlistId'),r.PLAYLIST_ID ),
           XMLELEMENT(EVALNAME('songId'), r.SONG_ID)
           ) as XML
    from PLAYLIST_SONGS r;
    loop
        fetch result_set into  xml_data;
        exit when result_set%notfound;
        xml_string:= xml_string || xml_data;
    end loop;
     xml_string:= xml_string || '</relationships>';
end;


--tests
-- declare
--     xml_string nvarchar2(10000);
-- begin
--      --export_genres_to_xml(xml_string);
--      --export_authors_to_xml(xml_string);
--      --export_songs_to_xml(xml_string);
--      --export_roles_to_xml(xml_string);
--      --export_users_to_xml(xml_string);
--      --export_playlists_to_xml(xml_string);
--      export_relationships_to_xml(xml_string);
--      DBMS_OUTPUT.PUT_LINE(xml_string);
-- end;