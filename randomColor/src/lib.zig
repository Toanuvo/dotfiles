// random_color.zig
// Zig 0.11+
//
// Core features ported from the uploaded randomColor.js:
// - options: hue (name | number | hex), luminosity ("bright","light","dark"), format ("hex","rgb","rgba")
// - seed: repeatable results
// - count: generate many
// - color bounds table and HSV→RGB/HEX
//
// Usage example:
// const gpa = std.heap.page_allocator;
// const out = try randomColor(.{ .format = .hex }, gpa);
// defer gpa.free(out);
// std.debug.print("{s}\n", .{out});

const std = @import("std");

pub const Format = enum { hex, rgb, rgba };

pub const Options = struct {
    hue: Hue = .any, // name | degrees | hex string
    luminosity: Luminosity = .random,
    format: Format = .hex,
    alpha: ?f32 = null, // 0..1 if format == rgba
    seed: ?i64 = null, // set for repeatable
    count: ?usize = null, // return many when set
};

pub const Luminosity = enum { random, bright, light, dark };
pub const Hue = union(enum) {
    any,
    name: ColorName,
    degrees: i32, // 0..360
    hex: []const u8, // "#RRGGBB" or "#RGB"
};

pub const ColorName = enum {
    monochrome,
    red,
    orange,
    yellow,
    green,
    blue,
    purple,
    pink,
};

const ColorInfo = struct {
    hueRange: ?[2]i32,
    lowerBounds: []const [2]i32,
    saturationRange: [2]i32,
    brightnessRange: [2]i32,
};

var g_seed: ?i64 = null;
var g_init_done = false;

const dict = struct {
    pub var map: std.AutoHashMap(ColorName, ColorInfo) = undefined;

    fn init(alloc: std.mem.Allocator) !void {
        if (g_init_done) return;
        g_init_done = true;
        map = std.AutoHashMap(ColorName, ColorInfo).init(alloc);

        // Port of loadColorBounds() and defineColor()
        try define(.monochrome, null, &.{
            .{ 0, 0 }, .{ 100, 0 },
        });

        try define(.red, .{ -26, 18 }, &.{
            .{ 20, 100 }, .{ 30, 92 }, .{ 40, 89 }, .{ 50, 85 }, .{ 60, 78 }, .{ 70, 70 }, .{ 80, 60 }, .{ 90, 55 },
            .{ 100, 50 },
        });

        try define(.orange, .{ 19, 46 }, &.{
            .{ 20, 100 }, .{ 30, 93 }, .{ 40, 88 }, .{ 50, 86 }, .{ 60, 85 }, .{ 70, 70 }, .{ 100, 70 },
        });

        try define(.yellow, .{ 47, 62 }, &.{
            .{ 25, 100 }, .{ 40, 94 }, .{ 50, 89 }, .{ 60, 86 }, .{ 70, 84 }, .{ 80, 82 }, .{ 90, 80 }, .{ 100, 75 },
        });

        try define(.green, .{ 63, 178 }, &.{
            .{ 30, 100 }, .{ 40, 90 }, .{ 50, 85 }, .{ 60, 81 }, .{ 70, 74 }, .{ 80, 64 }, .{ 90, 50 }, .{ 100, 40 },
        });

        try define(.blue, .{ 179, 257 }, &.{
            .{ 20, 100 }, .{ 30, 86 }, .{ 40, 80 }, .{ 50, 74 }, .{ 60, 60 }, .{ 70, 52 }, .{ 80, 44 }, .{ 90, 39 },
            .{ 100, 35 },
        });

        try define(.purple, .{ 258, 282 }, &.{
            .{ 20, 100 }, .{ 30, 87 }, .{ 40, 79 }, .{ 50, 70 }, .{ 60, 65 }, .{ 70, 59 }, .{ 80, 52 }, .{ 90, 45 },
            .{ 100, 42 },
        });

        try define(.pink, .{ 283, 334 }, &.{
            .{ 20, 100 }, .{ 30, 90 }, .{ 40, 86 }, .{ 60, 84 }, .{ 80, 80 }, .{ 90, 75 }, .{ 100, 73 },
        });
    }

    fn define(name: ColorName, hueRange: ?[2]i32, lower: []const [2]i32) !void {
        const sMin = lower[0][0];
        const sMax = lower[lower.len - 1][0];
        const bMin = lower[lower.len - 1][1];
        const bMax = lower[0][1];

        try map.put(name, .{
            .hueRange = hueRange,
            .lowerBounds = lower,
            .saturationRange = .{ sMin, sMax },
            .brightnessRange = .{ bMin, bMax },
        });
    }
};

fn seededBetween(min: i64, max: i64) i64 {
    // JS: seed = (seed * 9301 + 49297) % 233280;
    if (g_seed == null) @panic("seed not set");
    g_seed = (g_seed.? * 9301 + 49297) % 233280;
    // JS: var rnd = seed / 233280.0; return Math.floor(min + rnd * (max - min));
    const rnd = @as(f64, @floatFromInt(g_seed.?)) / 233280.0;
    return @as(i64, @intFromFloat(@floor(@as(f64, @floatFromInt(min)) + rnd * (@as(f64, @floatFromInt(max - min))))));
}

fn unseededBetween(rng: *std.rand.Random, min: i64, max: i64) i64 {
    // JS: var r = Math.random(); return Math.floor(min + r * (max - min + 1));
    const span = max - min + 1;
    return min + @as(i64, rng.intRangeAtMost(i64, 0, span - 1));
}

fn randomWithin(range: [2]i32, rng: *std.rand.Random) i32 {
    const lo = @as(i64, range[0]);
    const hi = @as(i64, range[1]);
    if (g_seed) |_| {
        return @intCast(seededBetween(lo, hi));
    } else {
        return @intCast(unseededBetween(rng, lo, hi));
    }
}

fn getHueRange(h: Hue, rng: *std.rand.Random) [2]i32 {
    switch (h) {
        .any => return .{ 0, 360 },
        .degrees => |deg| {
            // normalize
            var d = deg % 360;
            if (d < 0) d += 360;
            return .{ d, d };
        },
        .name => |n| {
            if (dict.map.get(n)) |ci| {
                if (ci.hueRange) |hr| return hr;
            }
            return .{ 0, 360 };
        },
        .hex => |hexstr| {
            // JS: var hue = HexToHSB(colorHue)[0];
            const hsv = hexToHSV(hexstr) catch return .{ 0, 360 };
            const hue_deg: i32 = hsv[0];
            // JS: return getColorInfo(hue).hueRange;
            return getColorInfo(hue_deg).hueRange orelse .{ 0, 360 };
        },
    }
}

fn pickHue(opts: Options, rng: *std.rand.Random) i32 {
    var range = getHueRange(opts.hue, rng);

    // JS: var hue = randomWithin(range);
    var hue = randomWithin(range, rng);

    // JS: if (hue < 0) hue = 360 + hue;
    if (hue < 0) hue = 360 + hue;

    return hue;
}

fn getSaturationRange(hue: i32) [2]i32 {
    const ci = getColorInfo(hue);
    return ci.saturationRange;
}

fn getMinimumBrightness(hue: i32, saturation: i32) i32 {
    const ci = getColorInfo(hue);
    // JS: linear interpolation across lowerBounds
    var lb = ci.lowerBounds;
    var i: usize = 0;
    while (i + 1 < lb.len) : (i += 1) {
        const s1 = lb[i][0];
        const v1 = lb[i][1];
        const s2 = lb[i + 1][0];
        const v2 = lb[i + 1][1];
        if (saturation >= s1 and saturation <= s2) {
            // JS: var m = (v2 - v1) / (s2 - s1);
            const m_num = v2 - v1;
            const m_den = s2 - s1;
            const m = @as(f64, @floatFromInt(m_num)) / @as(f64, @floatFromInt(m_den));
            // JS: var b = v1 - m * s1;
            const b = @as(f64, @floatFromInt(v1)) - m * @as(f64, @floatFromInt(s1));
            // JS: return m * saturation + b;
            const v = m * @as(f64, @floatFromInt(saturation)) + b;
            return @intFromFloat(@round(v));
        }
    }
    return 0;
}

fn pickSaturation(hue: i32, lum: Luminosity, rng: *std.rand.Random) i32 {
    var sat_range = getSaturationRange(hue);
    // JS: if (hue === 0 && hue === 'monochrome') return 0; -> monochrome handled by table

    var sMin = sat_range[0];
    var sMax = sat_range[1];

    // JS: switch(luminosity) adjust ranges
    switch (lum) {
        .random => {},
        .bright => {
            // JS: sMin = 55;
            if (sMin < 55) sMin = 55;
        },
        .light => {
            // JS: sMax = 55;
            if (sMax > 55) sMax = 55;
        },
        .dark => {
            // JS: sMin = sMax - 10;
            const n = sMax - 10;
            if (n > sMin) sMin = n;
        },
    }

    if (sMin < 0) sMin = 0;
    if (sMax > 100) sMax = 100;
    if (sMin > sMax) sMin = sMax;

    return randomWithin(.{ sMin, sMax }, rng);
}

fn pickBrightness(hue: i32, saturation: i32, lum: Luminosity, rng: *std.rand.Random) i32 {
    var bMin = getMinimumBrightness(hue, saturation);
    var bMax: i32 = 100;

    switch (lum) {
        .random => {},
        .bright => {
            // JS: bMin = Math.max(bMin, 55);
            if (bMin < 55) bMin = 55;
        },
        .light => {
            // JS: bMin = Math.max(bMin, 75);
            if (bMin < 75) bMin = 75;
        },
        .dark => {
            // JS: bMax = bMin + 20;
            const n = bMin + 20;
            if (n < bMax) bMax = n;
        },
    }

    if (bMax > 100) bMax = 100;
    if (bMin < 0) bMin = 0;
    if (bMin > bMax) bMin = bMax;

    return randomWithin(.{ bMin, bMax }, rng);
}

fn getColorInfo(hue: i32) ColorInfo {
    // JS: hue normalization and lookup by ranges
    var h = hue;
    if (h >= 334 and h <= 360) return dict.map.get(.red).?;
    if (h < 0) h = (h % 360) + 360;

    const keys = [_]ColorName{ .red, .orange, .yellow, .green, .blue, .purple, .pink, .monochrome };
    for (keys) |k| {
        if (dict.map.get(k)) |ci| {
            if (ci.hueRange) |hr| {
                if (h >= hr[0] and h <= hr[1]) return ci;
            } else if (k == .monochrome) {
                return ci;
            }
        }
    }
    return dict.map.get(.monochrome).?;
}

fn HSVtoRGB(hsv: [3]i32) [3]i32 {
    // JS: var h = hsv[0]; if (h === 0) h = 1; if (h === 360) h = 359;
    var h = hsv[0];
    if (h == 0) h = 1;
    if (h == 360) h = 359;

    // JS: h = h/360; s = s/100; v = v/100;
    const hf = @as(f64, @floatFromInt(h)) / 360.0;
    const sf = @as(f64, @floatFromInt(hsv[1])) / 100.0;
    const vf = @as(f64, @floatFromInt(hsv[2])) / 100.0;

    // JS: var i = Math.floor(h*6)
    const i: i32 = @intFromFloat(@floor(hf * 6.0));
    // JS: var f = h*6 - i;
    const f = hf * 6.0 - @as(f64, @floatFromInt(i));
    // JS: var p = v*(1-s)
    const p = vf * (1.0 - sf);
    // JS: var q = v*(1-f*s)
    const q = vf * (1.0 - f * sf);
    // JS: var t = v*(1-(1-f)*s)
    const t = vf * (1.0 - (1.0 - f) * sf);

    var r: f64 = 0;
    var g: f64 = 0;
    var b: f64 = 0;

    switch (i % 6) {
        0 => {
            r = vf;
            g = t;
            b = p;
        },
        1 => {
            r = q;
            g = vf;
            b = p;
        },
        2 => {
            r = p;
            g = vf;
            b = t;
        },
        3 => {
            r = p;
            g = q;
            b = vf;
        },
        4 => {
            r = t;
            g = p;
            b = vf;
        },
        else => {
            r = vf;
            g = p;
            b = q;
        },
    }

    // JS: Math.floor(r*255)
    return .{
        @intFromFloat(@floor(r * 255.0)),
        @intFromFloat(@floor(g * 255.0)),
        @intFromFloat(@floor(b * 255.0)),
    };
}

fn componentToHex(c: i32, buf: *[2]u8) void {
    // JS: var hex = c.toString(16); if (hex.length == 1) return "0"+hex;
    const hexchars = "0123456789abcdef";
    const hi: u8 = @intCast((c >> 4) & 0xF);
    const lo: u8 = @intCast(c & 0xF);
    buf.*[0] = hexchars[hi];
    buf.*[1] = hexchars[lo];
}

fn HSVtoHex(hsv: [3]i32, alloc: std.mem.Allocator) ![]u8 {
    const rgb = HSVtoRGB(hsv);
    var out = try alloc.alloc(u8, 7);
    out[0] = '#';
    var buf: [2]u8 = undefined;
    componentToHex(rgb[0], &buf);
    out[1] = buf[0];
    out[2] = buf[1];
    componentToHex(rgb[1], &buf);
    out[3] = buf[0];
    out[4] = buf[1];
    componentToHex(rgb[2], &buf);
    out[5] = buf[0];
    out[6] = buf[1];
    return out;
}

fn hexToHSV(hex: []const u8) ![3]i32 {
    var r: i32 = 0;
    var g: i32 = 0;
    var b: i32 = 0;

    if (hex.len == 7 and hex[0] == '#') {
        r = try parseHexByte(hex[1..3]);
        g = try parseHexByte(hex[3..5]);
        b = try parseHexByte(hex[5..7]);
    } else if (hex.len == 4 and hex[0] == '#') {
        r = try expandNibble(hex[1]);
        g = try expandNibble(hex[2]);
        b = try expandNibble(hex[3]);
    } else return error.InvalidHex;

    // convert RGB 0..255 to HSV degrees/sat/val
    const rf = @as(f64, @floatFromInt(r)) / 255.0;
    const gf = @as(f64, @floatFromInt(g)) / 255.0;
    const bf = @as(f64, @floatFromInt(b)) / 255.0;

    const maxv = std.math.max(std.math.max(rf, gf), bf);
    const minv = std.math.min(std.math.min(rf, gf), bf);
    const d = maxv - minv;

    var h: f64 = 0;
    if (d == 0) {
        h = 0;
    } else if (maxv == rf) {
        // JS: h = (gf - bf) / d + (gf < bf ? 6 : 0);
        h = (gf - bf) / d + (if (gf < bf) 6 else 0);
    } else if (maxv == gf) {
        // JS: h = (bf - rf) / d + 2;
        h = (bf - rf) / d + 2.0;
    } else {
        // JS: h = (rf - gf) / d + 4;
        h = (rf - gf) / d + 4.0;
    }
    // JS: h /= 6;
    h /= 6.0;

    const s: f64 = if (maxv == 0) 0 else d / maxv;
    const v: f64 = maxv;

    return .{
        @intFromFloat(@round(h * 360.0)),
        @intFromFloat(@round(s * 100.0)),
        @intFromFloat(@round(v * 100.0)),
    };
}

fn expandNibble(c: u8) !i32 {
    const v = try parseHexNibble(c);
    return @as(i32, v) * 17; // 0xF -> 0xFF
}

fn parseHexByte(s: []const u8) !i32 {
    return (@as(i32, try parseHexNibble(s[0])) << 4) | @as(i32, try parseHexNibble(s[1]));
}

fn parseHexNibble(c: u8) !u8 {
    return switch (c) {
        '0'...'9' => @intCast(c - '0'),
        'a'...'f' => @intCast(c - 'a' + 10),
        'A'...'F' => @intCast(c - 'A' + 10),
        else => error.InvalidHex,
    };
}

fn formatRGB(rgb: [3]i32, alpha: ?f32, alloc: std.mem.Allocator, fmt: Format) ![]u8 {
    var bw = std.io.fixedBufferStream(&[_]u8{});
    _ = &bw; // silence
    var list = std.ArrayList(u8).init(alloc);
    errdefer list.deinit();

    if (fmt == .rgb) {
        // JS: "rgb(" + r + "," + g + "," + b + ")"
        try list.writer().print("rgb({d},{d},{d})", .{ rgb[0], rgb[1], rgb[2] });
    } else {
        const a = alpha orelse 1.0;
        // JS: "rgba(" + r + "," + g + "," + b + "," + a + ")"
        try list.writer().print("rgba({d},{d},{d},{d:.6})", .{ rgb[0], rgb[1], rgb[2], a });
    }
    return list.toOwnedSlice();
}

fn buildOne(opts: Options, rng: *std.rand.Random, alloc: std.mem.Allocator) ![]u8 {
    // JS: var H = pickHue(options);
    const H = pickHue(opts, rng);
    // JS: var S = pickSaturation(H, options);
    const S = pickSaturation(H, opts.luminosity, rng);
    // JS: var B = pickBrightness(H, S, options);
    const B = pickBrightness(H, S, opts.luminosity, rng);

    const hsv = .{ H, S, B };

    switch (opts.format) {
        .hex => return HSVtoHex(hsv, alloc),
        .rgb, .rgba => {
            const rgb = HSVtoRGB(hsv);
            return try formatRGB(rgb, opts.alpha, alloc, opts.format);
        },
    }
}

pub fn randomColor(opts: Options, alloc: std.mem.Allocator) ![]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const a = alloc;

    try dict.init(a);

    // seed handling
    if (opts.seed) |s| {
        // JS: if (typeof seed === 'string') { seed = stringToInteger(seed); }
        g_seed = s;
    } else {
        g_seed = null;
    }

    var prng = std.Random.DefaultPrng.init(@bitCast(u64, std.time.nanoTimestamp()));
    var rng = prng.random();

    if (opts.count) |n| {
        var out = std.ArrayList(u8).init(a);
        errdefer out.deinit();

        // emit joined by '\n'
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const s = try buildOne(opts, &rng, a);
            defer a.free(s);
            if (i != 0) try out.append('\n');
            try out.appendSlice(s);
        }
        return out.toOwnedSlice();
    }

    return try buildOne(opts, &rng, a);
}

