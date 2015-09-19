(import
  [cuttlebot.command [commands]]
  asyncio)

(defmacro defn/command [name signature &rest body]
  (setv callable-name (str name))
  `(do (defn/async ~name [~@signature] ~@body)
       (import [cuttlebot.command [commands]])
       (commands.register ~callable-name ~name)))

(defmacro defn/async [name signature &rest body]
  `(with-decorator asyncio.coroutine (defn ~name [~@signature] ~@body)))

(defmacro/g! ap-switch [expr &rest checks]
  `(do (setv it ~expr)
       (cond ~@checks)))

(defmacro print/bot [message]
  `(yield-from (bot.post (get message "channel") (repr ~message))))
