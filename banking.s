.data
balance:  .word 5000
deposit:  .word 2000
withdraw: .word 8000

.text
main:
    la   t0, balance
    lw   t1, 0(t0)      # load balance = 5000

    # DEPOSIT: balance += 2000
    la   t2, deposit
    lw   t3, 0(t2)      # t3 = 2000
    add  t1, t1, t3     # t1 = 7000
    sw   t1, 0(t0)      # store 7000

    # WITHDRAW: check first, then subtract
    la   t2, withdraw
    lw   t3, 0(t2)      # t3 = 8000
    blt  t1, t3, error  # 7000 < 8000 ? go to error
    sub  t1, t1, t3
    sw   t1, 0(t0)
    j    done

error:
    addi t4, x0, -1     # error flag = -1

done:
    li   a7, 10
    ecall