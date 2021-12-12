-- получение треков для пользователя
create or replace view GET_SONG_FOR_USER
    as select s.ID, s.NAME as song, a2.NAME as author,g.GENRE,s.SOURCE from SONG S
            inner join GENRE G on S.GENRE = G.ID
                inner join AUTHOR A2 on A2.ID = S.AUTHOR;

-- получение лога удаление
create or replace view GET_DELETE_LOG
    as select * from VMUSIC_SONG_AUDIT
        where ACTION='DELETE'
            order by ACTION_DATE;

-- получение лога обновлений
create or replace view GET_UPDATE_LOG
    as select * from VMUSIC_SONG_AUDIT
        where ACTION='UPDATE'
            order by ACTION_DATE;

-- получение лога вставок данных
create or replace view GET_INSERT_LOG
    as select * from VMUSIC_SONG_AUDIT
        where ACTION='INSERT'
            order by ACTION_DATE;
