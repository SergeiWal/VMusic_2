const express = require("express");
const oracledb = require("oracledb");
const app = express();
const port = 3000;

try {
  oracledb.initOracleClient({ libDir: "C:\\Oracle\\instantclient_21_3" });
} catch (err) {
  console.error("Whoops!");
  console.error(err);
  process.exit(1);
}

const songRoter = require("./routers/song.router");
const userRouter = require("./routers/user.router");
const authorRouter = require("./routers/author.router");
const genreRouter = require("./routers/genre.router");
const playlistRouter = require("./routers/playlist.router");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/songs", songRoter);
app.use("/users", userRouter);
app.use("/authors", authorRouter);
app.use("/genres", genreRouter);
app.use("/playlists", playlistRouter);

app.listen(port, () => {
  console.log("VMusic-Server is started ...");
});
