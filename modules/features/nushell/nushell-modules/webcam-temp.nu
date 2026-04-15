export def main [
  temperature: int # Temperature to set webcam to - e.g. 5500
] {
  v4l2-ctl -c white_balance_automatic=0
  v4l2-ctl -c white_balance_temperature=$temperature
}
