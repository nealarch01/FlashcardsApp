import { Request, Response } from "express";

import AuthenticationToken from "../middlewares/authentication-token";
import verifyRequestBody from "../middlewares/verify-request-body";

import { GenericTypes as types } from "../utils/types";

import CardSetModel from "../models/card-set-model";

class CardSetController {
    // POST
    async createCardSet(req: Request, res: Response) {
        const authToken = req.headers.authorization;
        if (authToken === undefined) {
            return res.status(401).send({
                message: "Authorization was not provided"
            });
        }
        const reqBody = JSON.parse(req.body);
        const reqBodyErr = verifyRequestBody(reqBody, ["title", "description"], [types.string, types.string]);
        if (reqBodyErr !== null) {
            return res.status(400).send({
                message: "Invalid title or description format."
            });
        }
        const user_id = AuthenticationToken.decode(authToken);
        const title = reqBody.title;
        const description = reqBody.description;

        let newCardSetID = await CardSetModel.createCardSet(user_id!, title, description);
        return res.status(201).send({
            new_resource_id: newCardSetID,
            message: "Card set created successfully.",
        });
    }

    async deleteCardSet(req: Request, res: Response) {
        const authToken = req.headers.authorization || "";
        if (!AuthenticationToken.isValid(authToken)) {
            return res.status(400).send({
                message: "Invalid authorization token."
            });
        }

        const setID = parseInt(req.params.set_id);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid setID format."
            });
        }

        // Check if the user owns the set
        const user_id = AuthenticationToken.decode(authToken);
        const ownedSets = await CardSetModel.getCardSetsFromCreator(user_id!);
        if (!ownedSets.some(set => set.id === setID)) {
            return res.status(400).send({
                message: "You do not own this set."
            });
        }

        let deleteStatus = await CardSetModel.deleteCardSet(user_id!, setID);

        if (deleteStatus === true) {
            return res.status(200).send({
                message: "Card set deleted successfully."
            });
        }
        return res.status(500).send({
            message: "Card set could not be deleted."
        });
    }


    // GET 
    async getCardsInSet(req: Request, res: Response) {
        const setID = parseInt(req.params.set_id);
        if (isNaN(setID)) {
            return res.status(400).send({
                message: "Invalid set_id format."
            });
        }
        const cards = await CardSetModel.getCardsInSet(setID);
    }

    // GET 
}

export default new CardSetController();
