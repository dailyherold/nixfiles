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
    pkgs.qpwgraph # Qt patchbay for pipewire
    pkgs.helvum # GTK patchbay for pipewire
    pkgs.snapcast # Used for whome home audio streaming
  ];

  # Add host as a client to any snapserver on LAN
  systemd.user.services.snapclient-local = {
    wantedBy = [
      "pipewire.service"
    ];
    after = [
      "pipewire.service"
    ];
    serviceConfig = {
      ExecStart = "${pkgs.snapcast}/bin/snapclient --player pipewire";
    };
  };
}
