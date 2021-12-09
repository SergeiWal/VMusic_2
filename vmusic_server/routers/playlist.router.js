const express = require("express");
const dbconf = require("../config/config").dbconfig;
const orcldb = require("oracledb");
const router = express.Router();

router.get("/:user_id", async (req, res) => {
  let userId;

  if (req.params.user_id !== undefined) {
    userId = parseInt(req.params.user_id);
  } else {
    throw new Error("Bad request");
  }

  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.USERS_PLAYLIST_PKG.GET_PLAYLISTS_FOR_USER(:id, :ret);
     END;`,
    {
      id: userId,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.CURSOR },
    }
  );

  let resultSet = procedureResult.outBinds.ret;
  let resultArray = [];
  let row;
  while ((row = await resultSet.getRow())) {
    resultArray.push({
      id: row[0],
      name: row[1],
      author: row[2],
      genre: row[3],
      source: row[4],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.get("/:playlist_id/song", async (req, res) => {
  let playlistId;

  if (req.params.playlist_id !== undefined) {
    playlistId = parseInt(req.params.playlist_id);
  } else {
    throw new Error("Bad request");
  }

  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.USERS_PLAYLIST_PKG.GET_SONG_FROM_PLAYLIST(:id, :ret);
     END;`,
    {
      id: playlistId,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.CURSOR },
    }
  );

  let resultSet = procedureResult.outBinds.ret;
  let resultArray = [];
  let row;
  while ((row = await resultSet.getRow())) {
    resultArray.push({
      id: row[0],
      name: row[1],
      author: row[2],
      genre: row[3],
      source: row[4],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.post("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_name;
  let in_user;

  if (req.body.name === undefined || req.body.user === undefined) {
    throw new Error("Bad request");
  } else {
    in_name = req.body.name;
    in_user = req.body.user;
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.USERS_PLAYLIST_PKG.CREATE_PLAYLIST_FOR_USER(:name, :user, :ret);
     END;`,
    {
      name: in_name,
      user: in_user,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
      user: in_user,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

router.post("/:playlist_id/song/:song_id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_song_id;
  let in_playlist_id;

  if (
    req.params.song_id === undefined ||
    req.params.playlist_id === undefined
  ) {
    throw new Error("Bad request");
  } else {
    in_playlist_id = parseInt(req.params.playlist_id);
    in_song_id = parseInt(req.params.song_id);
  }

  let procedureResult = await connection.execute(
    `
    BEGIN 
     DB_ADMIN.USERS_PLAYLIST_PKG.ADD_SONG_IN_PLAYLIST(:playlist_id, :song_id, :ret);
     END;`,
    {
      playlist_id: in_playlist_id,
      song_id: in_song_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (!result) {
    throw new Error("Add song in playlist failed");
  }

  const response = { status: result !== 0 ? "Success" : "Failed" };
  res.json(response);
});

router.delete("/:playlist_id/song/:song_id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_song_id;
  let in_playlist_id;

  if (
    req.params.song_id === undefined ||
    req.params.playlist_id === undefined
  ) {
    throw new Error("Bad request");
  } else {
    in_playlist_id = parseInt(req.params.playlist_id);
    in_song_id = parseInt(req.params.song_id);
  }

  let procedureResult = await connection.execute(
    `
    BEGIN 
    DB_ADMIN.USERS_PLAYLIST_PKG.DELETE_SONG_FROM_PLAYLIST(:playlist_id, :song_id, :ret);
    END;`,
    {
      playlist_id: in_playlist_id,
      song_id: in_song_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (!result) {
    throw new Error("Delete song from playlist failed");
  }

  const response = { status: result !== 0 ? "Success" : "Failed" };
  res.json(response);
});

router.delete("/:id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;

  if (req.params.id === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = parseInt(req.params.id);
  }

  let procedureResult = await connection.execute(
    `
    BEGIN 
      DB_ADMIN.USERS_PLAYLIST_PKG.DELETE_PLAYLIST(:id, :ret);
     END;`,
    {
      id: in_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (!result) {
    throw new Error("Delete playlist failed");
  }

  const response = { status: result !== 0 ? "Success" : "Failed" };
  res.json(response);
});

router.patch("/:id/:name", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_name;

  if (req.params.id === undefined || req.params.name === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = parseInt(req.params.id);
    in_name = req.params.name;
  }

  let procedureResult = await connection.execute(
    `
    BEGIN 
      DB_ADMIN.USERS_PLAYLIST_PKG.UPDATE_PLAYLIST_NAME(:id, :name, :ret);
     END;`,
    {
      id: in_id,
      name: in_name,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (result >= 0) {
    res.json({ id: result, name: in_name });
  } else {
    res.json({ status: "failed" });
  }
});

module.exports = router;
