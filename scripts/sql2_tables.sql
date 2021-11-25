
--создание таблиц входящих в схему

create table genre
(
  id number,
  genre nvarchar2(25),
  constraint pk_genre_id primary key (id)
);

create table author
(
  id number,
  name nvarchar2(30),
  constraint pk_author_id primary key (id)
);

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
--alter table song rename column song to name;

create table user_role
(
    id number,
    role nvarchar2(25),
    constraint pk_role_id primary key (id)
);

create table vmusic_user
(
  id number ,
  name nvarchar2(30),
  password nvarchar2(60),
  role number not null,
  constraint pk_user_id primary key (id),
  constraint fk_user_role foreign key (role) references user_role(id)
);

create table playlist
(
    id number,
    name nvarchar2(30),
    owner number not null,
    constraint pk_playlist primary key (id),
    constraint fk_owner foreign key (owner) references vmusic_user(id)
);

--drop table playlist;

create table playlist_songs
(
  playlist_id number not null ,
  song_id number not null ,
  constraint fk_playlist_id foreign key (playlist_id) references playlist(id),
  constraint fk_song_id foreign key (song_id) references song(id)
);