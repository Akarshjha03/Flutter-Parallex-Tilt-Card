![Banner](https://github.com/Akarshjha03/PocketProjects/blob/main/flutterbanner.png?raw=true)

<h1 align="center">Parallax Tilt Card</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Windows-lightgrey?style=for-the-badge" alt="Platform" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License" />
</p>

---

## 🚀 Project Description

Parallax Tilt Card is a Flutter application demonstrating advanced UI engineering without external dependencies. It implements a custom 3D rendering pipeline using Matrix4 transformations and accelerometer-mimicking gesture control. The project features custom shaders for dynamic lighting, golden glitter particle effects using BlendMode.overlay, and physics-based spring animations for realistic interaction.

---

## 📱 Demo

<table>
  <tr>
    <td align="center">
      <img src="assets/ss.jpg" width="300" alt="Screenshot" />
      <br />
      <b>Screenshot</b>
    </td>
    <td align="center">
      <img src="assets/promotion.gif" width="300" alt="Demo GIF" />
      <br />
      <b>Animation</b>
    </td>
  </tr>
</table>

## 🛠 Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **Rendering:** Skia / Impeller
- **Techniques:** 
  - `Matrix4` for 3D Perspective Transformations
  - `AnimationController` for Spring Physics
  - `ShaderMask` & `BlendMode.overlay` for Glitter/Gold Effects
  - `LinearGradient` for Holographic Shimmer

## ✨ Features
- **3D Parallax Tilt**: Card rotates based on gesture interaction with realistic perspective.
- **Physical Feedback**: Spring-based recoil animation when released.
- **Golden Aesthetics**: Custom shaders mimic gold reflection and glitter.
- **Dynamic Lighting**: Light sheen moves across the surface responding to tilt angle.

## 🚀 Performance
- **60fps/120fps Ready**: Optimized render loop using standard Flutter widgets.
- **Zero External Dependencies**: Built entirely with core Flutter primitives for maximum efficiency and small app size.

## 🔮 Future Enhancements
- [ ] Gyroscope support for device-tilt control (Mobile).
- [ ] Configurable tilt sensitivity.
- [ ] More archetype cards (The Rock, Cody Rhodes, etc.).

## 📥 Download
Get the latest release here: [GitHub Releases](https://github.com/Akarshjha03/Flutter-Parallex-Tilt-Card/releases)

---

## 🤝 Contributing
Contributions are welcome! Here's how you can help:

- Fork the repository
- Create a feature branch (git checkout -b feature/AmazingFeature)
- Commit your changes (git commit -m 'Add some AmazingFeature')
- Push to the branch (git push origin feature/AmazingFeature)
- Open a Pull Request

<p align="center">
  ⭐ If you find this project useful, please consider giving it a star — it really helps!
</p>
