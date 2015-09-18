(import
  [PJD5132.api [Power Volume]]
  [cuttlebot.command [commands]]
  asyncio
  serial)

(defmacro defn/async [name signature &rest body]
  `(with-decorator asyncio.coroutine (defn ~name [~@signature] ~@body)))

(defmacro/g! ap-switch [expr &rest checks]
  `(do (setv it ~expr)
       (cond ~@checks)))

(defmacro print/bot [message]
  `(yield-from (bot.post (get message "channel") ~message)))


(let [[s (serial.Serial  ; 115200 8N1
           :port     "/dev/ttyUSB0"
           :bytesize serial.EIGHTBITS
           :parity   serial.PARITY_NONE
           :stopbits serial.STOPBITS_ONE
           :baudrate 115200)]
      [power (Power s)]]
  (defn/async projector [bot message &rest args]
    (ap-switch (first args)
          [(= it 'on)     (print/bot (power.on))]
          [(= it 'off)    (print/bot (power.off))]
          [(= it 'status) (print/bot (power.status))]
          [true           (print/bot "unknown subcommand")]))
  (commands.register "projector" projector))
