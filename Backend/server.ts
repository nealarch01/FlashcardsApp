import express from "express";
// Required imports for https 
// import https from "https";
// import fs from "fs";

// Router imports
import UserAuthenticationRouter from "./src/routes/user-authentication-router";
import CardSetRouter from "./src/routes/card-set-router";

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


// Authentication routes
app.use(UserAuthenticationRouter.loginRouter);
app.use(UserAuthenticationRouter.registerRouter);

// Card set routes
app.use(CardSetRouter.getCardsInSet);
app.use(CardSetRouter.getCardsMetaData);
app.use(CardSetRouter.getCardSetsFromCreator);
app.use(CardSetRouter.getOwnedSets);
app.use(CardSetRouter.createCardSet);
app.use(CardSetRouter.deleteCardSet);
app.use(CardSetRouter.updateTitle);
app.use(CardSetRouter.updateDescription);

app.get("/test/:id", async (req: express.Request, res: express.Response) => {
    const authToken = req.headers.authorization || "";
    const id = req.params.id;
    console.log(authToken);
    return res.send({
        message: "Passed"
    });
});


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

