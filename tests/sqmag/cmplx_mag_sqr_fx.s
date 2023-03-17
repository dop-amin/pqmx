        .syntax unified
        .type   cmplx_mag_sqr_fx, %function
        .global cmplx_mag_sqr_fx

        .text
        .align 4
cmplx_mag_sqr_fx:
        push {r4-r12,lr}
        vpush {d0-d15}

        out   .req r0
        in    .req r1
        sz    .req r2

        qr   .req q0
        qi   .req q1
        qtmp .req q2
        qout .req q3

        lsr lr, sz, #2
        wls lr, lr, end
start:
        // deinterleave real/imag
        vld20.32        {qr, qi}, [in]
        vld21.32        {qr, qi}, [in]!
        // square real/imag
        vmulh.s32       qtmp, qr, qr
        vmulh.s32       qout, qi, qi
        // accumulate & halving
        vhadd.s32       qout, qout, qtmp
        vstrw.32        qout, [out], #16
        le              lr, start
end:

        vpop {d0-d15}
        pop {r4-r12,lr}

        bx lr
