const express = require("express");
const dbconf = require("../config/config").dbconfig;
const orcldb = require("oracledb");

const router = express.Router();

router.get("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.GET_SONGS(:ret);
     END;`,
    {
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

router.get("/admin", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.GET_SONGS_ADMIN(:ret);
     END;`,
    {
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
      source: row[2],
      author: row[3],
      genre: row[4],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.post("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_name;
  let in_source;
  let in_author;
  let in_genre;

  if (
    req.body.name === undefined ||
    req.body.source === undefined ||
    req.body.author === undefined ||
    req.body.genre === undefined
  ) {
    throw new Error("Bad request");
  } else {
    in_name = req.body.name;
    in_source = req.body.source;
    in_author = Number(req.body.author);
    in_genre = Number(req.body.genre);
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.ADD_SONG(:name, :source, :author, :genre, :ret);
     END;`,
    {
      name: in_name,
      source: in_source,
      author: in_author,
      genre: in_genre,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
      source: in_source,
      author: in_author,
      genre: in_genre,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
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
      DB_ADMIN.DELETE_SONG(:in, :ret);
     END;`,
    {
      in: in_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (!result) {
    throw new Error("Delete song failed");
  }

  const response = { status: result !== 0 ? "Success" : "Failed" };
  res.json(response);
});

router.put("/:id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_name;
  let in_source;
  let in_author;
  let in_genre;

  if (
    req.params.id === undefined ||
    req.body.name === undefined ||
    req.body.source === undefined ||
    req.body.author === undefined ||
    req.body.genre === undefined
  ) {
    throw new Error("Bad request");
  } else {
    in_id = Number(req.params.id);
    in_name = req.body.name;
    in_source = req.body.source;
    in_author = Number(req.body.author);
    in_genre = Number(req.body.genre);
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.UPDATE_SONG(:id, :name, :source, :author, :genre, :ret);
     END;`,
    {
      id: in_id,
      name: in_name,
      source: in_source,
      author: in_author,
      genre: in_genre,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
      source: in_source,
      author: in_author,
      genre: in_genre,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

router.patch("/:id/name", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_name;

  if (req.params.id === undefined || req.body.name === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = Number(req.params.id);
    in_name = req.body.name;
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.UPDATE_SONG_NAME(:id, :name, :ret);
     END;`,
    {
      id: in_id,
      name: in_name,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

router.patch("/:id/source", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_source;

  if (req.params.id === undefined || req.body.source === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = Number(req.params.id);
    in_source = req.body.source;
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.UPDATE_SONG_SOURCE(:id, :source, :ret);
     END;`,
    {
      id: in_id,
      source: in_source,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      source: in_source,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

router.patch("/:song_id/genre/:genre_id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_genre;

  if (req.params.song_id === undefined || req.params.genre_id === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = Number(req.params.song_id);
    in_genre = Number(req.params.genre_id);
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.UPDATE_SONG_GENRE(:id, :genre, :ret);
     END;`,
    {
      id: in_id,
      genre: in_genre,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      genre: in_genre,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

router.patch("/:song_id/author/:author_id", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_id;
  let in_author;

  if (req.params.song_id === undefined || req.params.author_id === undefined) {
    throw new Error("Bad request");
  } else {
    in_id = Number(req.params.song_id);
    in_author = Number(req.params.author_id);
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.UPDATE_SONG_AUTHOR(:id, :author, :ret);
     END;`,
    {
      id: in_id,
      author: in_author,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      author: in_author,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

module.exports = router;
