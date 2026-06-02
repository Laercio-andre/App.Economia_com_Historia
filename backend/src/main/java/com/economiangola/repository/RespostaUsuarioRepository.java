// src/main/java/com/economiangola/repository/RespostaUsuarioRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.RespostaUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RespostaUsuarioRepository extends JpaRepository<RespostaUsuario, Long> {

    List<RespostaUsuario> findByResultadoQuizId(Long resultadoQuizId);
}
