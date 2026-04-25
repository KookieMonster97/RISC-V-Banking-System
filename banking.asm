################################################
# PROJECT: SIMPLE RISC-V BASED MINI BANKING SYSTEM
# ARCHITECTURE: RISC-V (RV32I)
# PLATFORM: RARS / RIPES SIMULATOR
################################################
.data
    # --- STORAGE ---
    balance:    .word 0          # Memory location for account balance
    # --- UI STRINGS ---
    header:     .asciz "\n========== GROUP 1: MINI BANKING ==========\n"
    menu:       .asciz "\n1. Deposit\n2. Withdraw\n3. Check Balance\n4. Exit\nSelection: "
    
    # --- PROMPTS & MESSAGES ---
    p_dep:      .asciz "Enter amount to DEPOSIT: "
    p_wit:      .asciz "Enter amount to WITHDRAW: "
    m_bal:      .asciz "Current Account Balance: $"
    m_succ:     .asciz ">>> Transaction Successful!\n"
    m_err:      .asciz ">>> ERROR: Insufficient Funds!\n"
    m_exit:     .asciz "\nThank you for banking with Group 1. Goodbye!\n"
.text
.globl main
main:
    # Print Header Once
    li a7, 4
    la a0, header
    ecall
menu_loop:
    # 1. Display Menu
    li a7, 4
    la a0, menu
    ecall
    # 2. Get User Choice
    li a7, 5
    ecall
    mv t0, a0           # t0 stores user selection
    # 3. Control Logic (Branching)
    li t1, 1
    beq t0, t1, deposit_op
    li t1, 2
    beq t0, t1, withdraw_op
    li t1, 3
    beq t0, t1, balance_op
    li t1, 4
    beq t0, t1, exit_op
    
    j menu_loop         # Repeat on invalid input
# --- DEPOSIT LOGIC ---
deposit_op:
    li a7, 4
    la a0, p_dep
    ecall
    li a7, 5            # Read integer amount
    ecall
    mv t1, a0           # t1 = deposit amount
    la t2, balance      # Load address
    lw t3, 0(t2)        # Load current balance
    add t3, t3, t1      # Calculation
    sw t3, 0(t2)        # Update Memory
    
    li a7, 4
    la a0, m_succ
    ecall
    j menu_loop
# --- WITHDRAW LOGIC ---
withdraw_op:
    li a7, 4
    la a0, p_wit
    ecall
    li a7, 5            # Read integer amount
    ecall
    mv t1, a0           # t1 = withdrawal amount
    la t2, balance
    lw t3, 0(t2)        # Load current balance
    
    blt t3, t1, fail_wit # Logic: Check if funds exist
    
    sub t3, t3, t1      # Calculation
    sw t3, 0(t2)        # Update Memory
    
    li a7, 4
    la a0, m_succ
    ecall
    j menu_loop
fail_wit:
    li a7, 4
    la a0, m_err
    ecall
    j menu_loop
# --- BALANCE ENQUIRY ---
balance_op:
    li a7, 4
    la a0, m_bal
    ecall
    
    la t2, balance
    lw a0, 0(t2)        # Load balance for display
    li a7, 1            # Print Integer
    ecall
    
    li a0, 10           # Newline
    li a7, 11
    ecall
    j menu_loop
# --- EXIT ---
exit_op:
    li a7, 4
    la a0, m_exit
    ecall
    li a7, 10           # Exit program
    ecall