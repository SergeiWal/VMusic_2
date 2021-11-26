--tests

--get_playlists_for_user test
select * from PLAYLIST;
declare
    result_set sys_refcursor;
    playlist_row PLAYLIST%rowtype;
begin
    get_playlists_for_user(2, result_set);
    loop
        fetch result_set into playlist_row;
        exit when result_set%notfound;
        DBMS_OUTPUT.PUT_LINE(playlist_row.ID || ' ' || playlist_row.NAME || ' ' || playlist_row.OWNER );
    end loop;
end;

-- create_playlist_for_user & delete_playlist test & update_playlist_name
select * from PLAYLIST;
declare
    procedure_result boolean;
begin
    create_playlist_for_user('Sports',2,procedure_result);
end;

select * from PLAYLIST;
declare
    procedure_result boolean;
begin
    DELETE_PLAYLIST(3, procedure_result);
end;

declare
    procedure_result boolean;
begin
    UPDATE_PLAYLIST_NAME(3,'ForSport', procedure_result);
end;

--add_song_in_playlist & delete_song_from_playlist
select * from PLAYLIST_SONGS;
declare
    procedure_result boolean;
begin
    ADD_SONG_IN_PLAYLIST(3,1,procedure_result);
end;

declare
    procedure_result boolean;
begin
    DELETE_SONG_FROM_PLAYLIST(3,1,procedure_result);
end;

--get_songs
select * from SONG;
declare
    result_set sys_refcursor;
    song_row SONG%rowtype;
begin
    GET_SONGS( result_set);
    loop
        fetch result_set into song_row;
        exit when result_set%notfound;
        DBMS_OUTPUT.PUT_LINE(song_row.ID || ' ' || song_row.NAME || ' ' || song_row.GENRE );
    end loop;
end;