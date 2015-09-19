(import asyncio aiohttp json os.path os)
(require cuttlebot.dsl)

(defn get-api-key []
  (with [[fd (open (os.path.expanduser "~/.darksky.key") "r")]]
    (setv fskey (.strip (.read fd))))
  (setv key (os.environ.get "DARKSKY_APIKEY" fskey))
  key)

(defn/async get-weather [api-key lat lon]
  (setv response (yield-from (aiohttp.request "GET"
    (.format "https://api.forecast.io/forecast/{}/{},{}"
              api-key lat lon))))
  (raise (StopIteration (json.loads (.decode (yield-from (response.read)) "utf-8")))))


(defn/command weather [bot message &rest args]
  (setv weather (yield-from (get-weather (get-api-key)
                                         "38.89760" "-77.00616")))
  (print/bot (. weather ["hourly"] ["summary"])))
