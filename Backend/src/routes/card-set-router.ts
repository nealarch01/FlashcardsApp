import { Router } from "express";

    import CardSetController from "../controllers/card-set-controller";

class CardSetRouter {
    // GET 
    getCardsInSet = Router().get("/card-set/cards/:setID", CardSetController.getCardsInSet);

    // GET
    getCardSetsFromCreator = Router().get("/card-set/:user_id", CardSetController.getCardSetsFromCreator);

    // POST 
    createCardSet = Router().post("/card-set/create", CardSetController.createCardSet)

    // DELETE
    deleteCardSet = Router().delete("/card-set/delete/:setID", CardSetController.deleteCardSet)

    // PUT
    updateTitle = Router().put("/card-set/update-title/", CardSetController.updateCardSetTitle)

    // PUT 
    updateDescription = Router().put("/card-set/update-description/", CardSetController.updateCardSetDescription) 


    // GET
    getCardSetMetaDataFromID = Router().get("/card-set/metadata/:setID", CardSetController.getCardSetMetaDataFromID)
}

export default new CardSetRouter();
