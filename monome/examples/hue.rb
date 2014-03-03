require File.join(File.dirname(__FILE__), '..', 'lib', 'monome')

class HueMonome < Monome::Application
  on :initialize do
    @hue = Hue::Client.new bridge: '10.0.38.13'
  end

  on :key do |column, row, state|
    next unless state == 1
    next unless row % 2 == 0
    next if column > 4
    light = @hue.lights[row / 2]
    puts light.name
    ctr = Hue::Light::COLOR_TEMPERATURE_RANGE
    target_temperature = (column * (ctr.size / 4)) + ctr.first
    light.color_temperature = target_temperature
  end

  on :key do |column, row, state|
    next unless state == 1
    next unless row % 2 == 0
    next if column < 4
    light = @hue.lights[row / 2]
    puts light.name
    hr = Hue::Light::HUE_RANGE
    target_hue = (column - 4) * (hr.size / 4)
    light.hue = target_hue
    light.saturation = Hue::Light::SATURATION_RANGE.last
  end

  on :key do |column, row, state|
    next unless state == 1
    next unless row % 2 == 1
    light = @hue.lights[row / 2]
    puts light.name
    target_brightness = column * (Hue::Light::BRIGHTNESS_RANGE.size / 8)
    light.brightness = target_brightness
  end
end
