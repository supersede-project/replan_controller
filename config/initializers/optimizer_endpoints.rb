uri_D1 = "http://supersede.es.atos.net:8280/replan_optimizer/replan"
uri_D2 = "http://supersede.es.atos.net:8280/replan_optimizer_v2/replan"
uri_P1 = "http://platform.supersede.eu:8280/replan_optimizer/replan"
uri_P2 = "http://platform.supersede.eu:8280/replan_optimizer_v2/replan"

local = "https://replan-optimizer-llavor.herokuapp.com/replan"

Rails.application.config.x.optimizer_endpoints = [local]

localn = "https://replan-optimizer-llavor.herokuapp.com/replan-n"

Rails.application.config.x.optimizer_n_endpoints = [localn]