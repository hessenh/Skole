################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/decision_tree_learning.c \
../src/importance.c \
../src/main.c \
../src/plurality_value.c \
../src/types.c 

OBJS += \
./src/decision_tree_learning.o \
./src/importance.o \
./src/main.o \
./src/plurality_value.o \
./src/types.o 

C_DEPS += \
./src/decision_tree_learning.d \
./src/importance.d \
./src/main.d \
./src/plurality_value.d \
./src/types.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -I"/home/stian/workspaces/Skole/TDT4171 Task4 - Code/include" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


