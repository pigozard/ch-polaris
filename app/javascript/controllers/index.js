import { application } from "controllers/application"
import TabsController from "./tabs_controller"
application.register("tabs", TabsController)
import AnnuaireController from "./annuaire_controller"
application.register("annuaire", AnnuaireController)
