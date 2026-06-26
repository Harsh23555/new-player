import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_player/core/theme/app_theme.dart';
import 'package:nova_player/shared/providers/global_equalizer_provider.dart';
import 'package:nova_player/features/audio/providers/equalizer_provider.dart' show kEqPresets, kEqBandHz;

class EqualizerSheet extends ConsumerWidget {
  const EqualizerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eq = ref.watch(globalEqProvider);
    final notifier = ref.read(globalEqProvider.notifier);

    return _CommonEqualizerSheet(eq: eq, notifier: notifier);
  }
}

class VideoEqualizerSheet extends ConsumerWidget {
  const VideoEqualizerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eq = ref.watch(globalEqProvider);
    final notifier = ref.read(globalEqProvider.notifier);

    return _CommonEqualizerSheet(eq: eq, notifier: notifier);
  }
}

class _CommonEqualizerSheet extends StatelessWidget {
  final dynamic eq;
  final dynamic notifier;

  const _CommonEqualizerSheet({required this.eq, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.tune_rounded, color: AppTheme.primaryViolet, size: 28),
                      const SizedBox(width: 12),
                      Text('Equalizer & Effects', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(onPressed: notifier.reset, icon: const Icon(Icons.refresh_rounded, color: Colors.white70)),
                      Switch.adaptive(
                        value: eq.enabled,
                        onChanged: (val) => notifier.toggle(),
                        activeColor: AppTheme.primaryViolet,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _title('Presets'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: kEqPresets.keys.map((name) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(name),
                            selected: eq.preset == name,
                            onSelected: eq.enabled ? (_) => notifier.applyPreset(name) : null,
                            selectedColor: AppTheme.primaryViolet.withOpacity(0.3),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _title('Frequency Bands'),
                    const SizedBox(height: 20),
                    Container(
                      height: 220,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (i) => _BandSlider(
                          hz: kEqBandHz[i],
                          gain: eq.gains[i],
                          enabled: eq.enabled,
                          onChanged: (db) => notifier.setBandGain(i, db),
                        )),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(child: _EffectSlider(title: 'Bass Boost', value: eq.bassBoost / 1000, enabled: eq.enabled, onChanged: (v) => notifier.setBassBoost((v * 1000).toInt()))),
                        const SizedBox(width: 20),
                        Expanded(child: _EffectSlider(title: '3D Virtualizer', value: eq.virtualizer / 1000, enabled: eq.enabled, onChanged: (v) => notifier.setVirtualizer((v * 1000).toInt()))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _title('Preamp (Volume Boost)'),
                    Row(
                      children: [
                        const Icon(Icons.volume_down_rounded, color: Colors.white30),
                        Expanded(
                          child: Slider(
                            value: eq.preamp,
                            min: 1.0, max: 3.0,
                            onChanged: eq.enabled ? (v) => notifier.setPreamp(v) : null,
                            activeColor: AppTheme.primaryViolet,
                          ),
                        ),
                        Text('${(eq.preamp * 100).round()}%', style: TextStyle(color: eq.enabled ? AppTheme.primaryViolet : Colors.white30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Text(text.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2));
}

class _EffectSlider extends StatelessWidget {
  final String title;
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _EffectSlider({required this.title, required this.value, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: enabled ? Colors.white : Colors.white30, fontSize: 14)),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)),
          child: Slider(value: value, onChanged: enabled ? onChanged : null, activeColor: AppTheme.primaryViolet),
        ),
      ],
    );
  }
}

class _BandSlider extends StatelessWidget {
  final int hz;
  final double gain;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _BandSlider({required this.hz, required this.gain, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${gain.round()}dB', style: TextStyle(fontSize: 11, color: enabled ? AppTheme.primaryViolet : Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
              child: Slider(value: gain, min: -15, max: 15, onChanged: enabled ? onChanged : null, activeColor: AppTheme.primaryViolet),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(hz >= 1000 ? '${(hz/1000).toInt()}k' : '$hz', style: const TextStyle(fontSize: 11, color: Colors.white54)),
      ],
    );
  }
}
