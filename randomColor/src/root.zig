//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;
const Rng = std.Random;

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub const Format = enum { hex, rgb, rgba };

pub const Options = struct {
    hue: Hue = .any,
    luminosity: Luminosity = .bright,
    format: Format = .hex,
    alpha: ?f32 = null, // 0..1 if format == rgba
    seed: ?i64 = null, // set for repeatable
    count: ?usize = null, // return many when set
    rng: Rng = undefined,
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

fn defineColor(hueRange: ?[2]i32, lower: []const [2]i32) ColorInfo {
    const sMin = lower[0][0];
    const sMax = lower[lower.len - 1][0];
    const bMin = lower[lower.len - 1][1];
    const bMax = lower[0][1];
    return .{
        .hueRange = hueRange,
        .lowerBounds = lower,
        .saturationRange = .{ sMin, sMax },
        .brightnessRange = .{ bMin, bMax },
    };
}

const Colors = std.EnumArray(ColorName, ColorInfo).init(.{
    .monochrome = defineColor(null, &.{
        .{ 0, 0 }, .{ 100, 0 },
    }),

    .red = defineColor(.{ -26, 18 }, &.{
        .{ 20, 100 }, .{ 30, 92 }, .{ 40, 89 }, .{ 50, 85 }, .{ 60, 78 }, .{ 70, 70 }, .{ 80, 60 }, .{ 90, 55 },
        .{ 100, 50 },
    }),

    .orange = defineColor(.{ 19, 46 }, &.{
        .{ 20, 100 }, .{ 30, 93 }, .{ 40, 88 }, .{ 50, 86 }, .{ 60, 85 }, .{ 70, 70 }, .{ 100, 70 },
    }),

    .yellow = defineColor(.{ 47, 62 }, &.{
        .{ 25, 100 }, .{ 40, 94 }, .{ 50, 89 }, .{ 60, 86 }, .{ 70, 84 }, .{ 80, 82 }, .{ 90, 80 }, .{ 100, 75 },
    }),

    .green = defineColor(.{ 63, 178 }, &.{
        .{ 30, 100 }, .{ 40, 90 }, .{ 50, 85 }, .{ 60, 81 }, .{ 70, 74 }, .{ 80, 64 }, .{ 90, 50 }, .{ 100, 40 },
    }),

    .blue = defineColor(.{ 179, 257 }, &.{
        .{ 20, 100 }, .{ 30, 86 }, .{ 40, 80 }, .{ 50, 74 }, .{ 60, 60 }, .{ 70, 52 }, .{ 80, 44 }, .{ 90, 39 },
        .{ 100, 35 },
    }),

    .purple = defineColor(.{ 258, 282 }, &.{
        .{ 20, 100 }, .{ 30, 87 }, .{ 40, 79 }, .{ 50, 70 }, .{ 60, 65 }, .{ 70, 59 }, .{ 80, 52 }, .{ 90, 45 },
        .{ 100, 42 },
    }),

    .pink = defineColor(.{ 283, 334 }, &.{
        .{ 20, 100 }, .{ 30, 90 }, .{ 40, 86 }, .{ 60, 84 }, .{ 80, 80 }, .{ 90, 75 }, .{ 100, 73 },
    }),
});

fn randomWithin(range: [2]i32, rng: Rng) i32 {
    //generate random evenly destinct number from : https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/
    const golden_ratio = 0.618033988749895;
    var r = rng.float(f64);
    //generate random evenly destinct number from : https://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/
    r += golden_ratio;
    r = @mod(r, 1);

    const lo: f64 = @floatFromInt(range[0]);
    const hi: f64 = @floatFromInt(range[1]);

    return @intFromFloat(@floor(lo + r * (hi + 1 - lo)));
}

fn getHueRange(h: Hue) ![2]i32 {
    return switch (h) {
        .any => .{ 0, 360 },
        .degrees => |deg| if (0 < deg and deg < 360) .{ deg, deg } else .{ 0, 360 },
        .name => |n| if (Colors.get(n).hueRange) |hr| hr else .{ 0, 360 },
        .hex => |hexstr| b: {
            const hsv = hexToHSB(hexstr) catch return .{ 0, 360 };
            break :b (try getColorInfo(hsv[0])).hueRange orelse .{ 0, 360 };
        },
    };
}

fn pickHue(color: Hue, rng: Rng) !i32 {
    const range = try getHueRange(color);

    var hue = randomWithin(range, rng);
    if (hue < 0) hue = 360 + hue;

    return hue;
}

fn getMinimumBrightness(hue: i32, saturation: i32) !i32 {
    const lb = (try getColorInfo(hue)).lowerBounds;
    for (0..lb.len - 1) |i| {
        const s1 = lb[i][0];
        const v1 = lb[i][1];
        const s2 = lb[i + 1][0];
        const v2 = lb[i + 1][1];
        if (s1 <= saturation and saturation <= s2) {
            // JS: var m = (v2 - v1) / (s2 - s1);
            const vd: f64 = @floatFromInt(v2 - v1);
            const sd: f64 = @floatFromInt(s2 - s1);
            const m = vd / sd;
            const b = @as(f64, @floatFromInt(v1)) - m * @as(f64, @floatFromInt(s1));
            const v = m * @as(f64, @floatFromInt(saturation)) + b;
            return @intFromFloat(@round(v));
        }
    }
    return 0;
}

fn pickSaturation(hue_val: i32, hue: Hue, luminosity: Luminosity, rng: Rng) !i32 {
    if (hue == .name and hue.name == .monochrome) {
        return 0;
    }

    const ci = try getColorInfo(hue_val);
    const sat_range = ci.saturationRange;
    var sMin = sat_range[0];
    var sMax = sat_range[1];

    switch (luminosity) {
        .random => {
            sMin = 0;
            sMax = 100;
        },
        .bright => {
            sMin = 55;
        },
        .light => {
            sMax = 55;
        },
        .dark => {
            sMin = sMax - 10;
        },
    }

    return randomWithin(.{ sMin, sMax }, rng);
}

fn pickBrightness(hue: i32, saturation: i32, luminosity: Luminosity, rng: Rng) !i32 {
    var bMin = try getMinimumBrightness(hue, saturation);
    var bMax: i32 = 100;

    switch (luminosity) {
        .random => {
            bMin = 0;
            bMax = 100;
        },
        .light => {
            bMin = @divTrunc(bMax + bMin, 2);
        },
        .dark => {
            bMax = bMin + 20;
        },
        else => {},
    }
    return randomWithin(.{ bMin, bMax }, rng);
}

fn getColorInfo(_hue: i32) !ColorInfo {
    // map red colors
    const hue = if (334 <= _hue and _hue <= 360) _hue - 360 else _hue;

    inline for (Colors.values) |ci| {
        if (ci.hueRange) |hr| {
            if (hr[0] <= hue and hue <= hr[1]) {
                return ci;
            }
        }
    }
    return error.ColorNotFound;
}

fn componentToHex(c: i32, buf: *[2]u8) void {
    // JS: var hex = c.toString(16); if (hex.length == 1) return "0"+hex;
    const hexchars = "0123456789abcdef";
    const hi: u8 = @intCast((c >> 4) & 0xF);
    const lo: u8 = @intCast(c & 0xF);
    buf.*[0] = hexchars[hi];
    buf.*[1] = hexchars[lo];
}

fn HSVtoRGB(hsv: [3]i32) [3]u8 {
    var h: f64 = @floatFromInt(hsv[0]);
    if (h == 0) h = 1;
    if (h == 360) h = 359;

    h = h / 360.0;
    const s = @as(f64, @floatFromInt(hsv[1])) / 100.0;
    const v = @as(f64, @floatFromInt(hsv[2])) / 100.0;
    const h_i = @floor(h * 6);

    const f = h * 6.0 - h_i;
    const p = v * (1.0 - s);
    const q = v * (1.0 - f * s);
    const t = v * (1.0 - (1.0 - f) * s);

    var r: f64 = 256;
    var g: f64 = 256;
    var b: f64 = 256;

    switch (@as(i32, @intFromFloat(h_i))) {
        0 => {
            r = v;
            g = t;
            b = p;
        },
        1 => {
            r = q;
            g = v;
            b = p;
        },
        2 => {
            r = p;
            g = v;
            b = t;
        },
        3 => {
            r = p;
            g = q;
            b = v;
        },
        4 => {
            r = t;
            g = p;
            b = v;
        },
        5 => {
            r = v;
            g = p;
            b = q;
        },
        else => {},
    }

    return .{
        @intFromFloat(@floor(r * 255.0)),
        @intFromFloat(@floor(g * 255.0)),
        @intFromFloat(@floor(b * 255.0)),
    };
}

fn hexToHSB(hex: []const u8) ![3]i32 {
    var buf: [3]u8 = undefined;
    const rgb = try std.fmt.hexToBytes(&buf, hex[1..]);
    const r = rgb[0];
    const g = rgb[1];
    const b = rgb[2];

    const maxi = std.mem.indexOfMax(u8, rgb);
    const cMax = rgb[maxi];
    const delta: f64 = @floatFromInt(cMax - @min(r, g, b));
    const saturation = if (cMax == 0) 0 else delta / @as(f64, @floatFromInt(cMax));

    const rf: f64 = @floatFromInt(r);
    const gf: f64 = @floatFromInt(g);
    const bf: f64 = @floatFromInt(b);

    const hue = switch (maxi) {
        0 => @mod(60 * ((gf - bf) / delta), 6),
        1 => @mod(60 * ((bf - rf) / delta), 6),
        2 => @mod(60 * ((rf - gf) / delta), 6),
        else => unreachable,
    };
    return .{ @intFromFloat(hue), @intFromFloat(saturation), cMax };
}

fn formatRGB(rgb: [3]i32, alpha: ?f32, alloc: std.mem.Allocator, fmt: Format, writer: std.Io.Writer) ![]u8 {
    _ = writer;
    var bw = std.Io.fixedBufferStream(&[_]u8{});
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

pub fn randomColor(opts: *Options, writer: *std.Io.Writer) !void {
    var prng = std.Random.DefaultPrng.init(@bitCast(opts.seed orelse std.time.microTimestamp()));
    opts.rng = prng.random();

    const H = try pickHue(opts.hue, opts.rng);
    const S = try pickSaturation(H, opts.hue, opts.luminosity, opts.rng);
    const B = try pickBrightness(H, S, opts.luminosity, opts.rng);

    const hsv = .{ H, S, B };

    const rgb = HSVtoRGB(hsv);
    switch (opts.format) {
        .hex => {
            try writer.print("#{X:0>2}{X:0>2}{X:0>2}", .{ rgb[0], rgb[1], rgb[2] });
        },
        .rgb => {
            try writer.print("rgb({d},{d},{d})", .{ rgb[0], rgb[1], rgb[2] });
        },
        .rgba => {
            try writer.print("rgba({d},{d},{d},{d:.6})", .{ rgb[0], rgb[1], rgb[2], opts.alpha orelse 1.0 });
        },
    }
}
