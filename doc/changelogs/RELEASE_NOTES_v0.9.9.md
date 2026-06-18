# Snapmaker Orca Full(er) Spectrum v0.9.9

This fork extends Snapmaker Orca FullSpectrum into **Full(er) Spectrum** by adding a shell-blend mode for virtual mixed colors. The new behavior is focused on making two real filament colors look more like a third blended color on the visible skin of the print.

It does not physically mix filament inside the nozzle. Instead, it places two real colors in a controlled outer-wall / inner-wall relationship, then also splits visible top and bottom surface lines between those same colors so the blend effect is visible from more angles.

## Quick Overview

- Adds an **Add Shell Blend** button to the Mixed Filaments panel.
- Automatically creates shell-blend entries for every two-filament pair you have loaded.
- Creates both directions for each pair, because the outside color and inside color can produce different-looking shades.
- Shows these entries as **Outer F# / Inner F#** so the relationship is clear.
- Uses the outermost wall for one filament and the next wall for the second filament.
- Splits visible top and bottom solid surface paths between the two filaments, instead of letting those faces collapse back to one color.
- Keeps hidden sparse/internal infill mostly on the existing behavior to avoid wasting tool changes where the color is not visible.
- Includes a regression test proving fixed outer/inner shell patterns stay stable across layers.

## What "Outer F# / Inner F#" Means

A shell-blend row has two real filament colors:

- **Outer F#** is the filament used on the outside wall, the wall your eye sees first.
- **Inner F#** is the filament used on the next shell behind that outer wall.

For example:

- **Outer F1 / Inner F2** means filament 1 is printed on the outside wall and filament 2 is printed just behind it.
- **Outer F2 / Inner F1** flips that relationship.

The flipped version matters because the visible result can change depending on which color sits outside. A blue outside with yellow behind it may look different from yellow outside with blue behind it. Red outside with white behind it may look different from white outside with red behind it. That gives you shade control instead of one fixed mix.

## Why This Is More Than Red + Blue = Purple

The shell-blend feature is generic. It is not hardcoded to any specific color pair.

If your loaded filaments are blue, yellow, red, and white, Full(er) Spectrum can create shell-blend choices like:

- Blue outside / Yellow inside
- Yellow outside / Blue inside
- Red outside / White inside
- White outside / Red inside
- Yellow outside / Red inside
- Red outside / Yellow inside

The slicer still uses real physical filaments, but the close placement of those colors can create a perceived blended color: green-ish, pink-ish, orange-ish, purple-ish, or other combinations depending on filament opacity, line width, wall count, and lighting.

## Side Walls

On side walls, Full(er) Spectrum uses shell depth:

- The outermost perimeter uses the outer filament.
- The next perimeter uses the inner filament.
- Deeper shell paths continue following the fixed grouped shell pattern.

This keeps the outer/inner assignment stable across layers. The outside color does not randomly swap every layer, which is important because random swapping would make the side color inconsistent.

## Top And Bottom Surfaces

The original FullSpectrum behavior could create good-looking thin-line illusions, but visible top faces could still end up wrong because the solid top surface often collapsed to one physical filament.

Full(er) Spectrum improves that by splitting visible top and bottom solid surface paths between the two component filaments. In practical terms, the top face should now get neighboring surface lines from both colors instead of only one of them winning.

This is especially important for flat parts, text, badges, lids, coasters, swatches, and other prints where the top surface is a major visible color area.

## What It Does Not Do

- It does not physically blend molten plastic inside the nozzle.
- It does not guarantee exact paint-like color math.
- It does not automatically know the perfect recipe for a target color.
- It does not make every filament pair blend equally well; opacity and translucency matter a lot.
- It does not remove the need for normal multi-material tuning, purging, wipe towers, and tool-change cleanup.

## Best Use Tips

- Use at least two walls/perimeters so there is a real outer wall and inner wall to work with.
- Print small swatches first before committing to a large model.
- Try both directions of a pair. **Outer Red / Inner White** and **Outer White / Inner Red** may produce noticeably different pinks.
- Lighter, thinner, or slightly translucent filaments may show the blend effect more strongly.
- Very opaque dark filaments may dominate the visual result.

## Existing FullSpectrum / Local-Z Notes

This build also carries the existing FullSpectrum work around Local-Z toolchange reduction, prime tower planning, and physical-color geometry correctness:

- Reduces Local-Z toolchanges by batching same-plane work across objects and scheduling Local-Z passes with dependency chains.
- Reworks Local-Z prime tower behavior so Local-Z swaps are planned ahead of time instead of using oversized reserve slots.
- Fixes Local-Z prime tower correctness issues, including missing plan lookups, final-purge sentinel handling, and empty nominal-toolchange layers.
- Fixes classic Local-Z physical-color regions so ordinary physical filament zones stay at nominal layer height instead of inheriting mixed-row micro-heights.
- Keeps whole-object Local-Z behavior available, while giving physical-color zones a clean two-pass split instead of arbitrary mixed-row pass heights.

## Notes

- Windows portable builds are unsigned custom fork builds, so Windows may show a warning the first time you run them.
- macOS builds from this fork remain unsigned and not notarized.
- Use at your own risk, and inspect important G-code before trusting it on a long or expensive print.
