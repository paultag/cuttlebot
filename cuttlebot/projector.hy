(import
  [PJD5132.api [Power Volume Mute]]
  asyncio
  serial)

(require cuttlebot.dsl)

(let [[s (serial.Serial  ; 115200 8N1
           :port     "/dev/ttyUSB0"
           :bytesize serial.EIGHTBITS
           :parity   serial.PARITY_NONE
           :stopbits serial.STOPBITS_ONE
           :baudrate 115200)]
      [power (Power s)]
      [mute  (Mute s)]]
  (defn/command projector [bot message &rest args]
    (ap-switch (first args)
          [(= it 'mute)   (print/bot (mute.on))]
          [(= it 'unmute) (print/bot (mute.off))]

          [(= it 'on)     (print/bot (power.on))]
          [(= it 'off)    (print/bot (power.off))]

          [(= it 'status) (print/bot (power.status))]
          [true           (print/bot "unknown subcommand")])))
