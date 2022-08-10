import { Router } from "express";

    import CardSetController from "../controllers/card-set-controller";

class CardSetRouter {
    // GET 
    getCardsInSetRouter = Router().get("/card-set/cards/:setID", CardSetController.getCardsInSet);

    // GET
    getCardSetsFromCreatorRouter = Router().get("/card-set/:user_id", CardSetController.getCardSetsFromCreator);

    // POST 
    createCardSetRouter = Router().post("/card-set/create", CardSetController.createCardSet)

    // DELETE
    deleteCardSetRouter = Router().delete("/card-set/delete/:setID", CardSetController.deleteCardSet)

    // PUT
    updateTitleRouter = Router().put("/card-set/update-title/", CardSetController.updateCardSetTitle)

    // PUT 
    updateDescriptionRouter = Router().put("/card-set/update-description/", CardSetController.updateCardSetDescription) 

    // GET
    getCardSetsFromCreator = Router().get("/card-set/:user_id", CardSetController.getCardSetsFromCreator)

    // GET
    getCardSetMetaDataFromID = Router().get("/card-set/metadata/:setID", CardSetController.getCardSetMetaDataFromID)

    // GET
    getCardsInSet = Router().get("/card-set/:setID", CardSetController.getCardsInSet)
}

export default new CardSetRouter();
