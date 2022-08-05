import { Router } from "express";

import UserController from "../controllers/user-controller";

class UserAuthenticationRouter {
    loginRouter = Router().post("/auth/login", UserController.login);
    registerRouter = Router().post("/auth/register", UserController.createAccount);
}

export default new UserAuthenticationRouter();
