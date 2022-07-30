import express from "express";
// Required imports for https 
// import https from "https";
// import fs from "fs";

// Router imports
import UserAuthenticationRouter from "./src/routes/user-authentication-router";

const app = express();

const port: number = 1000

app.use(express.text({
    type: "application/json"
}));

app.get("/", (req: express.Request, res: express.Response) => {
    return res.send({
        "statusCode": 200,
        "message": "OK"
    });
});

app.use(UserAuthenticationRouter.loginRouter);
app.use(UserAuthenticationRouter.registerRouter);
app.use(UserAuthenticationRouter.checkTokenRouter);
app.use(UserAuthenticationRouter.renewToken);


// For https
/* const httpsServer = https.createServer({
    key: fs.readFileSync("./server.key"),
    cert: fs.readFileSync("./server.cert")
}, app);

httpsServer.listen(port, () => {
    console.log(`Listening at: https://127.0.0.1:${port}`);
}); */

// http
app.listen(port, () => {
    console.log(`Lisetning at: http://127.0.0.1:${port}`);
});

