
-- admin procedures for work with songs
create or replace package ADMIN_SONG_PKG is

procedure get_songs_admin
    (result_set out sys_refcursor);

procedure add_song
    (in_name in nvarchar2, in_source in nvarchar2, in_author in number,
     in_genre in number ,procedure_result out number);

procedure delete_song
    (s_id in number, procedure_result out number);

procedure update_song_name
    (s_id in number, new_name in nvarchar2,  procedure_result out number);

procedure update_song_source
    (s_id in number, new_source in nvarchar2,  procedure_result out number);

procedure update_song_genre
    (s_id in number, new_genre in number,  procedure_result out number);

procedure update_song_author
    (s_id in number, new_author in number,  procedure_result out number);

procedure update_song
    (s_id in number, new_name in nvarchar2, new_source in nvarchar2,
        new_author in number, new_genre in number,
          procedure_result out number);
end ADMIN_SONG_PKG;


create or replace package body  ADMIN_SONG_PKG is

procedure get_songs_admin
    (result_set out sys_refcursor) is
begin
    open result_set for
        select * from SONG;
end;

procedure add_song
    (in_name in nvarchar2, in_source in nvarchar2, in_author in number,
     in_genre in number ,procedure_result out number) is
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
    procedure_result:=song_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure delete_song
    (s_id in number, procedure_result out number) is
begin
    delete from PLAYLIST_SONGS where SONG_ID = s_id;
    delete  from SONG where ID = s_id;
    procedure_result:=1;
    commit ;
    exception when others
        then
    procedure_result:= 0;
    rollback;
end;

procedure update_song_name
    (s_id in number, new_name in nvarchar2,  procedure_result out number) is
begin
    update SONG set NAME=new_name
        where ID=s_id;
    procedure_result:=s_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure update_song_source
    (s_id in number, new_source in nvarchar2,  procedure_result out number) is
begin
    update SONG set SOURCE=new_source
        where ID=s_id;
    procedure_result:=s_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure update_song_genre
    (s_id in number, new_genre in number,  procedure_result out number) is
begin
    update SONG set GENRE=new_genre
        where ID=s_id;
    procedure_result:=s_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure update_song_author
    (s_id in number, new_author in number,  procedure_result out number) is
begin
    update SONG set AUTHOR=new_author
        where ID=s_id;
    procedure_result:=s_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure update_song
    (s_id in number, new_name in nvarchar2, new_source in nvarchar2,
        new_author in number, new_genre in number,
          procedure_result out number) is
begin
    update SONG set NAME=new_name,
                    SOURCE=new_source,
                    AUTHOR=new_author,
                    GENRE=new_genre
        where ID=s_id;
    procedure_result:=s_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;
end ADMIN_SONG_PKG;

-- admins procedures for work with users

create or replace package ADMIN_USERS_PKG is

procedure get_users
    (result_set out sys_refcursor);

procedure delete_user
    (user_id in number, procedure_result out number);

procedure set_admin_role_for_user
    (user_id in number, procedure_result out number);

end ADMIN_USERS_PKG;

create or replace package body ADMIN_USERS_PKG is

procedure get_users
    (result_set out sys_refcursor) is
begin
    open result_set for
        select v.ID, v.NAME, ur.ROLE from VMUSIC_USER V inner join USER_ROLE UR on UR.ID = V.ROLE;
end;

procedure delete_user
    (user_id in number, procedure_result out number) IS
BEGIN
    delete from PLAYLIST_SONGS where PLAYLIST_ID in
                                     (select ID from PLAYLIST
                                        where OWNER = user_id);
    delete from PLAYLIST where OWNER=user_id;
    delete from VMUSIC_USER where ID=user_id;
    procedure_result:=user_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

procedure set_admin_role_for_user
    (user_id in number, procedure_result out number) is
begin
    update VMUSIC_USER set ROLE = 2 where ID=user_id;
    procedure_result:=user_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;

end ADMIN_USERS_PKG;

-- admins procedures with authors

create or replace package ADMIN_AUTHORS_PKG is
    procedure get_authors
        (result_set out sys_refcursor);
    procedure add_authors
        (authors_name in nvarchar2, procedure_result out number);
end ADMIN_AUTHORS_PKG;


create or replace package body ADMIN_AUTHORS_PKG is

procedure get_authors
    (result_set out sys_refcursor) is
begin
    open result_set for
        select * from AUTHOR;
end;

procedure add_authors
    (authors_name in nvarchar2, procedure_result out number) is
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
    procedure_result:=author_id;
    commit ;
    exception when others
        then
    procedure_result:= -1;
    rollback;
end;
end ADMIN_AUTHORS_PKG;