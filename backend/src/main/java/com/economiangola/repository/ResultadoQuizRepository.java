// src/main/java/com/economiangola/repository/ResultadoQuizRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ResultadoQuiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResultadoQuizRepository extends JpaRepository<ResultadoQuiz, Long> {

    List<ResultadoQuiz> findByUsuarioIdAndQuizId(Long usuarioId, Long quizId);

    long countByUsuarioIdAndQuizId(Long usuarioId, Long quizId);

    Optional<ResultadoQuiz> findByIdAndUsuarioId(Long id, Long usuarioId);

    List<ResultadoQuiz> findByUsuarioIdOrderByCriadoEmDesc(Long usuarioId);
}
