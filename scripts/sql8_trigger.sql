-- таблица для логирования
create table VMUSIC_SONG_AUDIT
(
  action_date date,
  action nvarchar2(30),
  description nvarchar2(400)
);


--триггер фиксирующий и записывающий в лог-таблицу изменения таблицы SONG

create or replace trigger song_after_trigger
    after insert or update or delete on SONG
    for each row
begin
    if inserting then
        insert into VMUSIC_SONG_AUDIT(ACTION_DATE, ACTION, DESCRIPTION)
            values (SYSDATE, 'INSERT','Added new song: ' || :new.NAME);
    end if;
    if updating then
     insert into VMUSIC_SONG_AUDIT(ACTION_DATE, ACTION, DESCRIPTION)
            values (SYSDATE, 'UPDATE','Update song, old value: ' || :old.NAME || ', ' || :old.AUTHOR
              || ', ' || :old.GENRE || ', ' || :old.SOURCE || ', ' || :old.AUTHOR ||
              '; new value: ' || :new.NAME || ', ' || :new.AUTHOR
              || ', ' || :new.GENRE || ', ' || :new.SOURCE || ', ' || :new.AUTHOR);
    end if;
    if deleting then
        insert into VMUSIC_SONG_AUDIT(ACTION_DATE, ACTION, DESCRIPTION)
            values (SYSDATE, 'DELETE','Delete song: ' || :old.NAME);
    end if;
end;

