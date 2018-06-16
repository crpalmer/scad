T=1.25;
T2=T/2;

module three() {
    linear_extrude(height=4/25.4) polygon([
      [ -1, 0], [-1.5, T2], [-1, 1.25], [-T2, 1.25],
      [-T2, 1.25 + 1], [0, 1.25 + 1.5], [T2, 1.25+1],
      [T2, 1.25], [1, 1.25], [1.5, T2], [1, 0]
    ]);
}

module four() {
    linear_extrude(height=4/25.4) polygon([
        [-T2, -T2], [-1, -T2], [-1.5, 0], [-1, T2], [-T2, T2],
        [-T2, 1], [0, 1.5], [T2, 1], [T2, T2],
        [1, T2], [1.5, 0], [1, -T2], [T2, -T2],
        [T2, -1], [0, -1.5], [-T2, -1], [-T2, -T2]
    ]);
}

module four2() {
    e=1;
    T2e=T2 + e;
    T2ee=T2 + 1.5*e;
    linear_extrude(height=4/25.4) polygon([
        [-T2, -T2], [-T2e, -T2], [-T2ee, 0], [-T2e, T2], [-T2, T2],
        [-T2, T2e], [0, T2ee], [T2, T2e], [T2, T2],
        [T2e, T2], [T2ee, 0], [T2e, -T2], [T2, -T2],
        [T2, -T2e], [0, -T2ee], [-T2, -T2e], [-T2, -T2]
    ]);
}

four2();