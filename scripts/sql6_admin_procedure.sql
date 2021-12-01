create or replace procedure get_songs_admin
    (result_set out sys_refcursor) is
begin
    open result_set for
        select * from SONG;
end;

create or replace procedure add_song
    (in_name in nvarchar2, in_source in nvarchar2, in_author in number,
     in_genre in number ,procedure_result out boolean) is
    is_song number := 0;
    song_id number;
begin
      select count(*) into is_song from SONG
        where NAME=in_name AND AUTHOR=in_author;
    if is_song = 0 then
    select count(*) into song_id from SONG;
    song_id:=song_id + 1;
    insert into SONG (ID, NAME, SOURCE, AUTHOR, GENRE)
        values (song_id, in_name, in_source, in_author, in_genre);
    end if;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure delete_song
    (s_id in number,  procedure_result out boolean) is
begin
    delete from PLAYLIST_SONGS where SONG_ID = s_id;
    delete  from SONG where ID = s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure update_song_name
    (s_id in number, new_name in nvarchar2,  procedure_result out boolean) is
begin
    update SONG set NAME=new_name
        where ID=s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure update_song_source
    (s_id in number, new_source in nvarchar2,  procedure_result out boolean) is
begin
    update SONG set SOURCE=new_source
        where ID=s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure update_song_genre
    (s_id in number, new_genre in number,  procedure_result out boolean) is
begin
    update SONG set GENRE=new_genre
        where ID=s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure update_song_author
    (s_id in number, new_author in number,  procedure_result out boolean) is
begin
    update SONG set AUTHOR=new_author
        where ID=s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure update_song
    (s_id in number, new_name in nvarchar2, new_source in nvarchar2,
        new_author in number, new_genre in number,
          procedure_result out boolean) is
begin
    update SONG set NAME=new_name,
                    SOURCE=new_source,
                    AUTHOR=new_author,
                    GENRE=new_genre
        where ID=s_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure get_users
    (result_set out sys_refcursor) is
begin
    open result_set for
        select v.ID, v.NAME, ur.ROLE from VMUSIC_USER V inner join USER_ROLE UR on UR.ID = V.ROLE;
end;

create or replace procedure delete_user
    (user_id in number, procedure_result out boolean) IS
BEGIN
    delete from PLAYLIST_SONGS where PLAYLIST_ID in
                                     (select ID from PLAYLIST
                                        where OWNER = user_id);
    delete from PLAYLIST where OWNER=user_id;
    delete from VMUSIC_USER where ID=user_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

--select * from USER_ROLE;
create or replace procedure set_admin_role_for_user
    (user_id in number, procedure_result out boolean) is
begin
    update VMUSIC_USER set ROLE = 2 where ID=user_id;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

create or replace procedure get_authors
    (result_set out sys_refcursor) is
begin
    open result_set for
        select * from AUTHOR;
end;

create or replace procedure add_authors
    (authors_name in nvarchar2, procedure_result out boolean) is
 is_author number := 0;
 author_id number;
begin
      select count(*) into is_author from AUTHOR
        where NAME=authors_name;
    if is_author = 0 then
    select count(*) into author_id from AUTHOR;
    author_id:=author_id + 1;
    insert into AUTHOR(ID, NAME)
        values (author_id, authors_name);
    end if;
    procedure_result:=true;
    commit ;
    exception when others
        then
    procedure_result:= false;
    rollback;
end;

-- create or replace procedure delete_author
--     (author_id in number,procedure_result out boolean ) is
-- begin
--      procedure_result:=true;
--     commit ;
--     exception when others
--         then
--     procedure_result:= false;
--     rollback;
-- end;