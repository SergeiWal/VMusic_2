const express = require("express");
const orcldb = require("oracledb");
const dbconf = require("../config/config").dbconfig;

const router = express.Router();

router.get("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.GET_USERS(:ret);
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
      role: row[2],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.post("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_name;
  let in_password;
  let in_role;

  if (
    req.body.name === undefined ||
    req.body.password === undefined ||
    req.body.role === undefined
  ) {
    throw new Error("Bad request");
  } else {
    in_name = req.body.name;
    in_password = req.body.password;
    in_role = Number(req.body.role);
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.CREATE_USER(:name, :password, :role, :ret);
     END;`,
    {
      name: in_name,
      password: in_password,
      role: in_role,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
      password: in_password,
      role: in_role,
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
      DB_ADMIN.DELETE_USER(:in, :ret);
     END;`,
    {
      in: in_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;

  if (!result) {
    throw new Error("Delete user failed");
  }

  const response = { status: result !== 0 ? "Success" : "Failed" };
  res.json(response);
});

router.patch("/:id", async (req, res) => {
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
      DB_ADMIN.SET_ADMIN_ROLE_FOR_USER(:in, :ret);
     END;`,
    {
      in: in_id,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = { status: "Success" };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

module.exports = router;
