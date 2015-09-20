(import
  [PJD5132.api [*]]
  [PJD5132.commands [*command-map* *command-types*]]
  asyncio
  serial)

(require cuttlebot.dsl)

(let [[s (serial.Serial  ; 115200 8N1
           :port     "/dev/ttyUSB0"
           :bytesize serial.EIGHTBITS
           :parity   serial.PARITY_NONE
           :stopbits serial.STOPBITS_ONE
           :baudrate 115200)]]

  (defn/command projector [bot message &rest args]
    (setv method (ap-switch (first args)

      [(= it 'mute)   mute]
      [(= it 'unmute) unmute]
      [(= it 'on)     power-on]
      [(= it 'off)    power-off]
      [(= it 'status) power-status]))

    (if (= method 'nil)
      (print/bot "No such method")
      (do (print/chan "#projector" #L"Doing: {method}")
          (print/bot (repr (method s)))))))
