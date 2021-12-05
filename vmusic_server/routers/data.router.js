const express = require("express");
const fs = require("fs");
const orcldb = require("oracledb");
const dbconf = require("../config/config").dbconfig;

const router = express.Router();
const xmlStart = '<?xml version="1.0" encoding="UTF-8" ?>';

const readFile = (fileName) => {
  return new Promise((resolve, reject) => {
    fs.readFile(fileName, (err, data) => {
      err ? reject(err) : resolve(data.toLocaleString());
    });
  });
};

router.post("/import/:type", async (req, res) => {
  if (req.params.type === undefined) {
    throw new Error("Bad request");
  }
  const type = req.params.type;
  readFile(`./static/data/${type}.xml`)
    .then((data) => {
      orcldb.getConnection(dbconf).then((connection) => {
        connection
          .execute(
            `BEGIN 
            DB_ADMIN.IMPORT_${type.toUpperCase()}_XML(:in);
            commit;
          END;`,
            {
              in: data,
            }
          )
          .then(() => {
            res.json({ status: "success" });
          });
      });
    })
    .catch((err) => {
      console.error("Read data error: ", err);
      res.json({ status: "failed" });
    });
});

router.get("/export/:type", async (req, res) => {
  if (req.params.type === undefined) {
    throw new Error("Bad request");
  }
  const type = req.params.type;

  const connection = await orcldb.getConnection(dbconf);

  const procedureResult = await connection.execute(
    `BEGIN 
         DB_ADMIN.EXPORT_${type.toUpperCase()}_TO_XML(:ret);
           commit;
          END;`,
    {
      ret: { dir: orcldb.BIND_OUT, type: orcldb.STRING, maxSize: 10000 },
    }
  );

  const xmlString = xmlStart + procedureResult.outBinds.ret;
  fs.writeFile(`./static/backup/${type}.xml`, xmlString, () => {});
  res.json({ status: "success" });
});

module.exports = router;
