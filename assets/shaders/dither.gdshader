shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool enable = true;
uniform float divisions : hint_range(0, 16, 1.0) = 3.0;
uniform float contrast : hint_range(0, 4) = 1.0;
uniform float shift : hint_range (-1, 1) = 0;
uniform bool use_palette;
uniform sampler2D palette;
// The Bayer matrix pattern to use
// 1 -> 2x2, 2 -> 4x4, 3 -> 8x8
uniform int bayer_pattern : hint_range(1, 3);
uniform bool grayscale;

const int matrix2[4] = {
    0, 2,
    3, 1
};
const int matrix4[16] = {
    0,  8,  2,  10,
    12, 4,  14, 6,
    3,  11, 1,  9,
    15, 7,  13, 5
};
const int matrix8[64] = {
    0,  32, 8,  40, 2,  34, 10, 42,
    48, 16, 56, 24, 50, 18, 58, 26,
    12, 44, 4,  36, 14, 46, 6,  38,
    60, 28, 52, 20, 62, 30, 54, 22,
    3,  35, 11, 43, 1,  33, 9,  41,
    51, 19, 59, 27, 49, 17, 57, 25,
    15, 47, 7,  39, 13, 45, 5,  37,
    63, 31, 55, 23, 61, 29, 53, 21
};

int getIndexValue(vec2 uv, int dSize) {
    int i = (int(uv.x) % dSize) + (int(uv.y) % dSize * dSize);

    switch (dSize) {
        case 2:
            return matrix2[i];
        case 4:
            return matrix4[i];
        default:
            return matrix8[i];
    }
}

void fragment() {
    if (!enable) {
        discard;
    }
    
    // Get dither size based on matrix selected
    int dSize = bayer_pattern == 1 ? 2 : (bayer_pattern == 2 ? 4 : 8);
    dSize *= 1;
    int dSquared = dSize * dSize;
    // Get space between divisions
    vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
    float div = divisions;

    if (use_palette) {
        ivec2 pSize = textureSize(palette, 0);
        pSize /= pSize.y;
        div = float(pSize.x) - 1.0;

        c.rgb = vec3((c.r * 0.299) + (c.g * 0.587) + (c.b * 0.114));
    }

    // add contrast and shift
    c = (c - 0.5 + shift) * contrast + 0.5;
    c = clamp(c, 0.0, 1.0);

    // get dither value
    int d = getIndexValue(UV / TEXTURE_PIXEL_SIZE, dSize);
    // normalize the dither value
    float dN = (float(d) / float(dSquared)) - 0.5;
    // get the normalizing value for the division gap
    float r = 1.0 / div;
    float l = r / float(dSquared * 2);

    c += r * dN + l; // add dither value to color
    c *= div; // convert normailzed color to quantized range
    c = round(c); // round to nearest available color
    c /= div; // normalize again

    if (use_palette) {
        c.rgb = texture(palette, vec2(c.r, 0.5)).rgb;
    }

    if (grayscale) {
        c.rgb = vec3((c.r + c.g + c.b) / 3.0);
    }

    COLOR.rgb = c.rgb;
}
