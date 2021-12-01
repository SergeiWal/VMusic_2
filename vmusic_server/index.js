const app = express();
const port = 3000;

const songRoter = require("./routers/song.router");
const userRouter = require("./routers/user.router");
const authorRouter = require("./routers/author.router");
const genreRouter = require("./routers/genre.router");
const playlistRouter = require("./routers/playlist.router");

app.use("/songs", songRoter);
app.use("/users", userRouter);
app.use("/authors", authorRouter);
app.use("/genre", genreRouter);
app.use("/playlists", playlistRouter);

app.listen(port, () => {
  console.log("VMusic-Server is started ...");
});
