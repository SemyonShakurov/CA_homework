#include <iostream>
#include <omp.h>
#include <math.h>

// Вывод информации о функции
void printFunctionInfo() {
	std::cout << "f(x) = sqrt(1 + x^3)" << std::endl;
	std::cout << "Чтобы вычислить определенный интеграл функции f(x)" << std::endl;
	std::cout << "с шагом интегрирования 0.001 на промежутке от a до b, введите" << std::endl;
}

// Ввод левой границы интегрирования
double getA(const char* msg) {
	char answer[256];
	double x;

	printf("%s", msg);
	fgets(answer, sizeof(answer), stdin);

	while (sscanf_s(answer, "%lf", &x) != 1 || x < -1) {
		printf("Incorrect input. Try again: ");
		fgets(answer, sizeof(answer), stdin);
	}

	return x;
}

// Ввод правой границы интегрирования.
double getB(const char* msg, double a) {
	char answer[256];
	double x;

	printf("%s", msg);
	fgets(answer, sizeof(answer), stdin);

	while (sscanf_s(answer, "%lf", &x) != 1 || x < -1 || a >= x) {
		printf("Incorrect input. Try again: ");
		fgets(answer, sizeof(answer), stdin);
	}

	return x;
}

// Функция, которую интегрируем.
double f(double x) {
	return sqrt(1 + pow(x, 3));
}

// Вычисление определенного интеграла с левой границей a, правой границей b, частотой интегрирования h
// Результат заносится в переменную res.
void integral(const double a, const double b, const double h, double* res) {
	int n = (int)((b - a) / h);
	double sum = 0.0;
	double value;
	int i;

	#pragma omp parallel for private (value) reduction(+: sum)
	for (i = 1; i <= n; i++) {
		value = h * f(a + h * (i - 0.5));
		sum += value;
	}
	
	*res = sum;
}

int main() {
	setlocale(LC_ALL, "Russian");
	printFunctionInfo();
	double a = getA("a (>= -1): ");
	double b = getB("b (>= -1 && > a): ", a);
	double h = 0.001;
	double res;

	integral(a, b, h, &res);
	std::cout << "Integral result: " << res << std::endl;
	system("pause");
	return 0;
}