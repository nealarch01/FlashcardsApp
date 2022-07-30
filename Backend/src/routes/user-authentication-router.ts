import { Router } from "express";

import UserController from "../controllers/user-controller";

class UserAuthenticationRouter {
    loginRouter = Router().post("/auth/login", UserController.login);
    registerRouter = Router().post("/auth/register", UserController.createAccount);
    checkTokenRouter = Router().post("/auth/check-token-active", UserController.checkTokenActive);
    renewToken = Router().post("/auth/renew-token", UserController.renewToken);
}

export default new UserAuthenticationRouter();
