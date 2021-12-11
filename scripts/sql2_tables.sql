
--создание таблиц входящих в схему

create table genre
(
  id number,
  genre nvarchar2(25) unique,
  constraint pk_genre_id primary key (id)
);
-- drop table genre;

create table author
(
  id number,
  name nvarchar2(30) unique ,
  constraint pk_author_id primary key (id)
);
-- drop table AUTHOR;

create table song
(
    id number,
    name nvarchar2(30),
    source nvarchar2(120),
    author number not null,
    genre number not null,
    constraint pk_song_id primary key (id),
    constraint fk_song_author foreign key(author) references author(id),
    constraint fk_song_genre foreign key (genre) references genre(id)
);
-- drop table song;
--alter table song rename column song to name;

create table user_role
(
    id number,
    role nvarchar2(25) unique ,
    constraint pk_role_id primary key (id)
);
-- drop table  user_role;

create table vmusic_user
(
  id number ,
  name nvarchar2(30) unique ,
  password nvarchar2(65),
  role number not null,
  constraint pk_user_id primary key (id),
  constraint fk_user_role foreign key (role) references user_role(id)
);

-- drop table  vmusic_user;
create table playlist
(
    id number,
    name nvarchar2(30),
    owner number not null,
    constraint pk_playlist primary key (id),
    constraint fk_owner foreign key (owner) references vmusic_user(id)
);

--drop table playlist;
-- drop table playlist_songs;

create table playlist_songs
(
  playlist_id number not null ,
  song_id number not null ,
  constraint fk_playlist_id foreign key (playlist_id) references playlist(id),
  constraint fk_song_id foreign key (song_id) references song(id)
);