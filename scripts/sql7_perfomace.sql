
--delete data from db
begin
    delete from PLAYLIST_SONGS;
    delete from PLAYLIST;
    delete from SONG;
    delete from VMUSIC_USER;
    delete from USER_ROLE;
    delete from AUTHOR;
    delete from GENRE;
    commit;
end;

--check data from tables

select * from GENRE;
select * from AUTHOR;
select * from USER_ROLE;
select * from VMUSIC_USER;
select * from SONG;
select * from PLAYLIST;
select * from PLAYLIST_SONGS;


--block for insert 100 000 rows
declare
    i number := 0;
    ln number := 100000;
begin
    insert into GENRE(id, GENRE)
            values(1, DBMS_RANDOM.STRING('a',10));
    insert into AUTHOR(id, NAME)
            values(1, DBMS_RANDOM.STRING('a',10));
    loop
        insert into SONG(ID,NAME,SOURCE,GENRE, AUTHOR) values
            (i, DBMS_RANDOM.STRING('a',20),DBMS_RANDOM.STRING('a',20),1,1);
        i:= i + 1;
        exit when  i = ln;
    end loop;
end;

select count(*) as ROWS_COUNT from SONG;

select *
from SONG;