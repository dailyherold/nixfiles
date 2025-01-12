{pkgs, ...}: {
  # Disable PulseAudio
  services.pulseaudio.enable = false;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  environment.systemPackages = [
    pkgs.pavucontrol #  GTK gui for controlling audio i/o and volumes
    pkgs.helvum # GTK patchbay for pipewire
  ];
}
