--хранимые процедуры для пользователя приложения с ролью - user

--получение плэйлистов конкретного пользователя
create or replace procedure get_playlists_for_user
    (user_id IN number, result_set OUT sys_refcursor) IS
begin
    open result_set for
        select * from PLAYLIST p
            where p.OWNER=user_id;
end;

--создание нового плэйлиста
create or replace procedure create_playlist_for_user
    (playlist_name IN nvarchar2, user_id IN number, procedure_result OUT number) IS
    playlist_id number:=0;
    is_playlist number:=0;
begin
    select count(*) into is_playlist from PLAYLIST
        where NAME=playlist_name AND OWNER=user_id;
    if is_playlist = 0 then
    select count(*) into playlist_id from PLAYLIST;
    playlist_id:=playlist_id + 1;
    insert into PLAYLIST (id, name, owner)
        values (playlist_id, playlist_name, user_id);
    end if;
    procedure_result:=playlist_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

--удаление плэйлиста
create or replace  procedure delete_playlist
    (in_playlist_id IN number, procedure_result OUT number) IS
begin
    delete from PLAYLIST_SONGS where PLAYLIST_ID=in_playlist_id;
    delete from PLAYLIST where ID=in_playlist_id;
    procedure_result:=1;
    commit ;
     exception when others
        then
    procedure_result:= 0;
    rollback ;
end;

select * from SONG
    where ID in (select ps.SONG_ID from PLAYLIST_SONGS ps
        where ps.PLAYLIST_ID = 1);

--получить треки из плэйлиста
create or replace procedure get_song_from_playlist
    (in_playlist_id IN number, procedure_result OUT sys_refcursor) is
begin
     open procedure_result for
        select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR
            where s.ID in (select ps.SONG_ID from PLAYLIST_SONGS ps
        where ps.PLAYLIST_ID = in_playlist_id);
end;

--добавить трек в плэйлист
create or replace procedure add_song_in_playlist
    (in_playlist_id IN number, in_song_id IN number,procedure_result OUT number) IS
    row_count number;
begin
    select count(*) into  row_count from PLAYLIST_SONGS
            where PLAYLIST_ID=in_playlist_id AND SONG_ID=in_song_id;
    if row_count=0 then
    insert into PLAYLIST_SONGS(playlist_id, song_id)
        values (in_playlist_id,in_song_id);
    end if;
    procedure_result:=1;
    commit ;
    exception when others
        then
    procedure_result:= 0;
    rollback;
end;

--удалить трек в плэйлисте
create or replace procedure delete_song_from_playlist
    (in_playlist_id IN number, in_song_id IN number,procedure_result OUT number) IS
begin
    delete from PLAYLIST_SONGS where SONG_ID=in_song_id AND PLAYLIST_ID=in_playlist_id;
    procedure_result:=1;
    commit ;
    exception when others
        then
    procedure_result:= 0;
    rollback;
end;

--обновление имени плэйлиста
create or replace procedure update_playlist_name
    (playlist_id IN number, new_name nvarchar2, procedure_result out number) IS
begin
    update PLAYLIST set NAME=new_name
        where ID=playlist_id;
    procedure_result:=playlist_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

--получение песен
create or replace procedure get_songs
    ( result_set OUT sys_refcursor) IS
begin
    open result_set for
        select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR;
end;

--получение песен по жанру
create or replace procedure get_songs_by_genre
    ( genre_id IN number, result_set OUT sys_refcursor) IS
begin
    open result_set for
        select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR
            where G.ID = genre_id;
end;


--получение песен по автору
create or replace procedure get_songs_by_author
    ( author_id IN number, result_set OUT sys_refcursor) IS
begin
    open result_set for
        select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR
            where A2.ID = author_id;
end;

--получение песен по подстроке в имени
create or replace procedure get_songs_by_name
    ( search_song IN nvarchar2, result_set OUT sys_refcursor) IS
begin
    open result_set for
         select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR
            where INSTRC(s.NAME, search_song) != 0 ;
end;


--получение жанров
create or replace procedure get_genres
    ( result_set OUT sys_refcursor) IS
begin
    open result_set for
        select * from GENRE;
end;

--создание пользователя

create or replace  procedure create_user
    (in_name in nvarchar2, in_password in nvarchar2, in_role in number, proc_result out number)
     is
    user_count number;
    user_id number;
begin
    proc_result := -1;
    select count(*) into user_count from VMUSIC_USER u where u.NAME = in_name;
    if user_count = 0 then
        select count(*) into user_id from VMUSIC_USER;
        insert into VMUSIC_USER (ID, NAME, PASSWORD, ROLE)
            values (user_id + 1, in_name, in_password, in_role);
        proc_result:=user_id + 1;
        commit ;
    end if;
    exception when others
        then
    proc_result := -1;
    rollback ;
end;

--авторизация
create or replace procedure sign_in
    (username in nvarchar2, in_password in nvarchar2, proc_result out number, result_set out sys_refcursor)
    is
    user_count number;
begin
    select count(*) into user_count from VMUSIC_USER u
        where  u.NAME = username and PASSWORD=in_password;
    proc_result:=-1;
    if user_count=1 then
        open result_set for
            select u.ID, u.NAME, ur.ROLE from VMUSIC_USER u
                inner join USER_ROLE UR on u.ROLE = UR.ID
                    where  NAME = username and PASSWORD=in_password;
        proc_result := 1;
    end if;
    commit;
    exception when others
        then
    proc_result:=-1;
    rollback ;
end;