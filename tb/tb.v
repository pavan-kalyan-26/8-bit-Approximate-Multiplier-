`timescale 1ns / 1ps

module tb_approx_mult_with_error;

    reg  [7:0]  a;
    reg  [7:0]  b;
    wire [15:0] product_approx;

    integer     exact_product;
    integer     abs_error;

    integer i, j;

    // ----- Error accumulation variables -----
    integer total_tests;
    real    total_abs_error;
    real    total_relative_error;
    real    total_error_percent;

    real    MAE;
    real    MRE;
    real    MRED;
    real    avg_percent_error;

    real    error_percent;     // <<< FIXED: Declare here, not inside loops

    // DUT
    approx_mult_8bit dut (
        .a(a),
        .b(b),
        .product(product_approx)
    );

    initial begin
        a = 0;
        b = 0;

        total_tests          = 0;
        total_abs_error      = 0.0;
        total_relative_error = 0.0;
        total_error_percent  = 0.0;

        $display("-------------------------------------------------------------");
        $display("  A    B   |   Exact    Approx   AbsError   Error(%%)       ");
        $display("-------------------------------------------------------------");

        // FULL 8-bit range: 0..255
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                a = i[7:0];
                b = j[7:0];

                #1;

                exact_product = a * b;

                // Absolute error
                if (exact_product >= product_approx)
                    abs_error = exact_product - product_approx;
                else
                    abs_error = product_approx - exact_product;

                // Error percentage
                if (exact_product != 0)
                    error_percent = (abs_error * 100.0) / exact_product;
                else
                    error_percent = 0.0;

                // Accumulate stats
                total_tests         = total_tests + 1;
                total_abs_error     = total_abs_error + abs_error;
                total_error_percent = total_error_percent + error_percent;

                if (exact_product != 0)
                    total_relative_error =
                        total_relative_error + (abs_error * 1.0 / exact_product);
                else
                    total_relative_error = total_relative_error + 0.0;

                // WARNING: this will print 65536 lines
                $display(" %3d  %3d | %7d  %7d  %8d   %6.2f",
                         a, b, exact_product, product_approx,
                         abs_error, error_percent);
            end
        end

        // Final metrics
        MAE  = total_abs_error / total_tests;
        MRE  = total_relative_error / total_tests;
        MRED = MRE;
        avg_percent_error = total_error_percent / total_tests;

        $display("-------------------------------------------------------------");
        $display(" Total test cases        = %0d", total_tests);
        $display(" Total Absolute Error    = %0f", total_abs_error);
        $display(" Mean Absolute Error     = %0f", MAE);
        $display(" Mean Relative Error     = %0f", MRE);
        $display(" Mean Relative Error Dist= %0f", MRED);
        $display(" Avg Error Percentage    = %0f %%", avg_percent_error);
        $display("-------------------------------------------------------------");

        $stop;
    end

endmodule
