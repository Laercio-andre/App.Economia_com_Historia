// src/main/java/com/economiangola/repository/PerfilEstudanteRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.PerfilEstudante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PerfilEstudanteRepository extends JpaRepository<PerfilEstudante, Long> {

    Optional<PerfilEstudante> findByUsuarioId(Long usuarioId);
}
