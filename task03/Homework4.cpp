#include <iostream>
#include <math.h>
#include <thread>

// Вывод информации о функции
void printFunctionInfo() {
	std::cout << "f(x) = sqrt(1 + x^3)" << std::endl;
	std::cout << "Чтобы вычислить определенный интеграл функции f(x)" << std::endl;
	std::cout << "c шагом интегрировния 0.001 на промежутке от a до b, введите" << std::endl;
}

//сама функция
double f(double x) {
	return sqrt(1 + pow(x, 3));
}

// Получение левой границы интеграла.
double getA(const char *msg) {
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

//Получение правой границы интеграла
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

double* arr; // Каждый поток отвечает за отдельный элемент в этом массиве

/// <summary>
/// Вычисление площадей прямоугольников отдельными потоками.
/// </summary>
/// <param name="number">Номер потока</param>
/// <param name="n">Количество разбиений на прямоугольники</param>
/// <param name="numberOfThreads">Количество потоков</param>
/// <param name="a">Левая граница интеграла</param>
/// <param name="h">Длина разделения на прямоугольники</param>
void square(int number, double n, int numberOfThreads, double a, double h) {
	for (int i = number + 1; i <= n; i += numberOfThreads) {
		double value = h * f(a + h * (i - 0.5));
		arr[number] += value;
	}
}

//Вычисление интеграла.
double integral(double a, double b, double h) {
	double n = (b - a) / h;
	int numberOfThreads = std::thread::hardware_concurrency();
	std::thread* threads = new std::thread[numberOfThreads];
	arr = new double[numberOfThreads];
	double sum = 0.0;

	for (int i = 0; i < numberOfThreads; i++) arr[i] = 0.0;

	for (int i = 0; i < numberOfThreads; i++) {
		threads[i] = std::thread(square, i, n, numberOfThreads, a, h);
		threads[i].join();
	}

	for (int i = 0; i < numberOfThreads; i++) {
		sum += arr[i];
		arr[i] = 0.0;
	}

	return sum;
}

int main() {
	setlocale(LC_ALL, "Russian");
	printFunctionInfo();
	double a = getA("a (>= -1): ");
	double b = getB("b (>= -1 && > a): ", a);
	double h = 0.001;
	
	double res = integral(a, b, h);
	std::cout << "Integral result: " << res << std::endl;
	system("pause");
	return 0;
}