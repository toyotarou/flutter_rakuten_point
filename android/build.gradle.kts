import com.android.build.gradle.LibraryExtension
import org.gradle.api.Project

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ビルド出力先をプロジェクト外の共通ディレクトリにリダイレクトしている場合の設定
val newBuildDir: Directory = rootProject
    .layout
    .buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {

    // サブプロジェクトごとに、ビルド出力先を newBuildDir/<moduleName> に変更
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // app モジュール（:app）が先に評価されるよう依存関係を設定
    project.evaluationDependsOn(":app")

    // ────────────────────────────────────────────────────────────────────────────
    // ① com.android.library が適用されているサブプロジェクト（ライブラリモジュール）に対して
    //    compileSdk = 35, targetSdk = 35 を強制的に上書きする
    // ────────────────────────────────────────────────────────────────────────────
    plugins.withId("com.android.library") {
        extensions.configure<LibraryExtension> {
            // 依存ライブラリが要求する最高 compileSdk（35）に合わせる
            compileSdk = 35
            // ライブラリモジュールでも、targetSdk を揃えておいたほうが安全
            defaultConfig {
                targetSdk = 35
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
